/** skkserv/skkdic.c --- rskkserv module for skkdic.

 * Copyright (C) 2001  YAMASHITA Junji

 * Author:	YAMASHITA Junji <ysjj@unixuser.org>
 * Version:	0.9

 * This file is part of rskkserv.

 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2, or (at
 * your option) any later version.

 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
**/

#define USE_MMAP 0
#define PROFILING 0

#if USE_MMAP
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#else
#include <stdio.h>
#endif /* USE_MMAP */
#if PROFILING
#include <sys/time.h>
#include <unistd.h>
#endif /* PROFILING */
#include <string.h>
#include <ruby.h>

#if USE_MMAP
typedef char *JISYO;
#else
typedef FILE *JISYO;
#endif

struct skkdic_data {
#if USE_MMAP
  int jisyo_fd;
  off_t jisyo_len;
#endif
  struct {
    int *ptr;
    int len;
  } a_tbl, n_tbl;
  JISYO jisyo;
};

static VALUE cSKKDic;

static VALUE fskkdic_s_data(VALUE, VALUE, VALUE, VALUE);
static VALUE fskkdic_s_search(VALUE, VALUE, VALUE);

#if PROFILING
static FILE *profile;
#endif

void Init_skkdic()
{
#if PROFILING
  profile = fopen("skkdic-mon.out", "w");
#endif

  rb_require("skkserv/skkdic.rb");

  cSKKDic = rb_define_class("SKKDic", rb_cObject);

  rb_define_singleton_method(cSKKDic, "data", fskkdic_s_data, 3);
  rb_define_singleton_method(cSKKDic, "search", fskkdic_s_search, 2);
}

#define FALSE 0
#define TRUE  1

static void fskkdic_data_free(struct skkdic_data *data)
{
  free(data->a_tbl.ptr);
  free(data->n_tbl.ptr);
#if USE_MMAP
  munmap(data->jisyo, data->jisyo_len);
  close(data->jisyo_fd);
#else
  fclose(data->jisyo);
#endif
}

static VALUE
fskkdic_s_data(VALUE self, VALUE path, VALUE a_tbl, VALUE n_tbl)
{
  struct skkdic_data *data;
  VALUE retval;

  retval = Data_Make_Struct(rb_cData, struct skkdic_data, 0,
			    fskkdic_data_free, data);

  data->a_tbl.len = RSTRING(a_tbl)->len / sizeof(int);
  data->a_tbl.ptr = ALLOC_N(int, data->a_tbl.len);
  memcpy(data->a_tbl.ptr, RSTRING(a_tbl)->ptr, RSTRING(a_tbl)->len);

  data->n_tbl.len = RSTRING(n_tbl)->len / sizeof(int);
  data->n_tbl.ptr = ALLOC_N(int, data->n_tbl.len);
  memcpy(data->n_tbl.ptr, RSTRING(n_tbl)->ptr, RSTRING(n_tbl)->len);

#if USE_MMAP
  {
    struct stat jisyo_stat;
    data->jisyo_fd = open(STR2CSTR(path), O_RDONLY);
    fstat(data->jisyo_fd, &jisyo_stat);
    data->jisyo_len = jisyo_stat.st_size;
    data->jisyo = (char*)mmap(0, data->jisyo_len,
			      PROT_READ, MAP_PRIVATE,
			      data->jisyo_fd, 0);
  }
#else
  data->jisyo = fopen(STR2CSTR(path), "r");
#endif

  return retval;
}

static int
is_okuri_ari(const char *kana, int len)
{
  const char c = kana[len-2];

  return (kana[0] & 0x80) && (c >= 'a' && c <= 'z');
}

static VALUE
fskkdic_s_search(VALUE self, VALUE vkana, VALUE vdata)
{
  char *kana = STR2CSTR(vkana);
  int kana_len = strlen(kana);
  int pos, left, right;
  int cmp, found;

#if USE_MMAP
  char *buf;
#else
  char buf[BUFSIZ];
#endif
  JISYO jisyo;
  struct skkdic_data *data;
  int *tbl_ptr;
  int tbl_len;
  VALUE retval = rb_ary_new();

#if PROFILING
  struct timeval start_time, found_time, end_time;
  int loop_count = 0;

  gettimeofday(&start_time, NULL);
#endif

  Data_Get_Struct(vdata, struct skkdic_data, data);
  jisyo = data->jisyo;

  if (is_okuri_ari(kana, kana_len)) {
    tbl_ptr = data->a_tbl.ptr;
    tbl_len = data->a_tbl.len;
  } else {
    tbl_ptr = data->n_tbl.ptr;
    tbl_len = data->n_tbl.len;
  }

  found = FALSE;
  left = 0;
  right = tbl_len - 1;

  while (left <= right) {
#if PROFILING
    loop_count++;
#endif

    pos = (left + right) / 2;

#if USE_MMAP
    buf = jisyo + tbl_ptr[pos];
#else
    fseek(jisyo, tbl_ptr[pos], SEEK_SET);
    fgets(buf, sizeof(buf), jisyo);
#endif
    cmp = strncmp(buf, kana, kana_len);
    if (cmp == 0) {
      found = TRUE;
      break;
    } else if (cmp > 0) {
      right = pos - 1;
    } else /* if (cmp < 0) */ {
      left = pos + 1;
    }
  }

#if PROFILING
  gettimeofday(&found_time, NULL);
#endif

  if (found) {
    char *p, *q;

    for (p = buf + kana_len + 1, q = p; *p != '\n'; p = q + 1) {
      while (*++q != '/')
	/* void */;
      rb_ary_push(retval, rb_str_new(p, q - p));
    }
  }

#if PROFILING
  {
    long search_usec, push_usec;

    gettimeofday(&end_time, NULL);

    search_usec = found_time.tv_usec - start_time.tv_usec;
    push_usec = end_time.tv_usec - found_time.tv_usec;
    if (search_usec < 0)
      search_usec += 1000 * 1000 * 1000;
    if (push_usec < 0)
      push_usec += 1000 * 1000 * 1000;

    fprintf(profile, "found: %3s, search usec (loop): %6d (%2d), ",
	    found ? "YES" : "NO", search_usec, loop_count);
    fprintf(profile, "build result: %3d\n", push_usec);
    fflush(profile);
  }
#endif

  return retval;
}

/** ext/skkdic.c ends here **/
