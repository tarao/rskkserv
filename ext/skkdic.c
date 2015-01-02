/** ext/skkdic.c --- rskkserv module for skkdic.

 * Copyright (C) 2001-2005 YAMASHITA Junji

 * Author:	YAMASHITA Junji <ysjj@unixuser.org>
 * Version:	0.11

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

#include <assert.h>
#include <string.h>
#include <ruby.h>

#if USE_MMAP
typedef char *JISYO;
#else
typedef FILE *JISYO;
#endif

struct skkdic_data {
  struct skkdic_tbl {
    int *ptr;
    int len;
  } a_tbl, n_tbl;
  int bufsize;
  JISYO jisyo;
#if USE_MMAP
  JISYO pos;
  off_t len;
  int fd;
#endif
};

#if USE_MMAP
#define skkdic_open(d,p) \
  do {\
    struct stat jisyo_stat;\
    (d)->fd = open(p, O_RDONLY);\
    fstat((d)->fd, &jisyo_stat);\
    (d)->len = jisyo_stat.st_size;\
    (d)->jisyo = (JISYO)mmap(0, (d)->len, PROT_READ, MAP_PRIVATE, (d)->fd, 0);\
  } while (0)

#define skkdic_close(d) \
  do {munmap((d)->jisyo, (d)->len); close((d)->fd);} while (0)

#define skkdic_seek(d,p) (d)->pos = (d)->jisyo + (p)
#define skkdic_getc(d) *((d)->pos++)

static inline int
skkdic_cmp(struct skkdic_data *skkdic, char *kana, int len)
{
  int result = strncmp(skkdic->pos, kana, len);
  skkdic->pos += len;
  return result;
}

#else /* ! USE_MMAP */
#define skkdic_open(d,p) (d)->jisyo = fopen(p, "r")
#define skkdic_close(d) fclose((d)->jisyo)
#define skkdic_seek(d,p) fseek((d)->jisyo, p, SEEK_SET)
#define skkdic_getc(d) fgetc((d)->jisyo)

static inline int
skkdic_cmp(struct skkdic_data *skkdic, char *kana, int len)
{
  unsigned char *p = (unsigned char*)kana;
  int c = EOF, n = 0, i = 0;
  while (len > i && (c=skkdic_getc(skkdic)) != EOF && (n=c-p[i++]) == 0)
    /* void */;
  if (c == EOF)
    return -1;
  return n;
}
#endif /* USE_MMAP */

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
  skkdic_close(data);
}

static VALUE
fskkdic_s_data(VALUE self, VALUE path, VALUE a_tbl, VALUE n_tbl)
{
  struct skkdic_data *data;
  VALUE retval;

  retval = Data_Make_Struct(rb_cData, struct skkdic_data, 0,
			    fskkdic_data_free, data);

  data->a_tbl.len = RSTRING_LEN(a_tbl) / sizeof(int);
  data->a_tbl.ptr = ALLOC_N(int, data->a_tbl.len);
  memcpy(data->a_tbl.ptr, RSTRING_PTR(a_tbl), RSTRING_LEN(a_tbl));

  data->n_tbl.len = RSTRING_LEN(n_tbl) / sizeof(int);
  data->n_tbl.ptr = ALLOC_N(int, data->n_tbl.len);
  memcpy(data->n_tbl.ptr, RSTRING_PTR(n_tbl), RSTRING_LEN(n_tbl));
  skkdic_open(data, StringValuePtr(path));
  data->bufsize = 16;

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
  char *kana = StringValuePtr(vkana);
  int kana_len = strlen(kana);
  int pos, left, right;
  int found;

  struct skkdic_data *skkdic;
  struct skkdic_tbl tbl;
  VALUE retval = rb_ary_new();

#if PROFILING
  struct timeval start_time, found_time, end_time;
  int loop_count = 0;
  gettimeofday(&start_time, NULL);
#endif

  Data_Get_Struct(vdata, struct skkdic_data, skkdic);

  tbl = is_okuri_ari(kana, kana_len) ? skkdic->a_tbl : skkdic->n_tbl;

  found = FALSE;
  left = 0;
  right = tbl.len - 1;

  while (left <= right) {
    int cmp;
#if PROFILING
    loop_count++;
#endif

    pos = (left + right) / 2;

    skkdic_seek(skkdic, tbl.ptr[pos]);
    cmp = skkdic_cmp(skkdic, kana, kana_len);
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
    int c = skkdic_getc(skkdic);

    assert(c == '/');
    for (c = skkdic_getc(skkdic); c != EOF && c != '\n'; c = skkdic_getc(skkdic)) {
      char *p = ALLOCA_N(char, skkdic->bufsize);
      int i = 0;
      p[i++] = c;
      while ((c=skkdic_getc(skkdic)) != '/') {
	if (i >= skkdic->bufsize) {
	  skkdic->bufsize *= 2;
	  p = memcpy(ALLOCA_N(char, skkdic->bufsize), p, i);
	}
	p[i++] = c;
      }
      rb_ary_push(retval, rb_str_new(p, i));
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
