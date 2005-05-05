### skkserv/skkdic.rb --- rskkserv module for skkdic format dictionary.

## Copyright (C) 1997-2000  Shugo Maeda
## Copyright (C) 2000,2001  YAMASHITA Junji

## Author:	Shugo Maeda <shugo@aianet.ne.jp>
## Maintainer:	YAMASHITA Junji <ysjj@unixuser.org>
## Version:	2.3.2d

## This file is part of rskkserv.

## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation; either version 2, or (at
## your option) any later version.

## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.

### History:

## 2000/12/22:
# split from skkserv.rb.in

### Code:

require "skkserv/logger"

begin
  require "skkserv/skkdic.so"
rescue LoadError
  Logger::log(Logger::WARNING, "%s: %s", $0, $!)
#  raise RuntimeError, "can't load `skkserv/skkdic.so'" # for DEBUG
end

class SKKDic
  include FileTest

  OKURI_ARI_LABEL = ";; okuri-ari entries.\n"
  OKURI_NASI_LABEL = ";; okuri-nasi entries.\n"
  OKURI_ARI_REGEXP = /[\xa1-\xfe][\xa1-\xfe].*[a-z] $/n
  
  def initialize(path, cachedir, nocache)
    @path = path
    @file = open(@path)
    
    @cache_a = File.expand_path(File.basename(@path) + ".a", cachedir)
    @cache_n = File.expand_path(File.basename(@path) + ".n", cachedir)
    @nocache = nocache
    @okuri_ari_regexp = OKURI_ARI_REGEXP

    if !@nocache && new_cache?
      @okuri_ari_table = read_cache(@cache_a)
      @okuri_nasi_table = read_cache(@cache_n)
      if @okuri_ari_table.nil? || @okuri_nasi_table.nil?
	make_table
      end
    else
      make_table
    end

    if SKKDic.respond_to?(:search)
      @data = SKKDic.data(@path,
			  @okuri_ari_table.pack("i*"),
			  @okuri_nasi_table.pack("i*"))
      @okuri_ari_table = nil
      @okuri_nasi_table = nil
      GC.start

      @search = proc {|kana| SKKDic.search(kana, @data)}
    else
      @search = proc {|kana| search_rb(kana)}
    end
  end
  
  def new_cache?
    return (exist?(@cache_a) &&  File.ctime(@path) < File.ctime(@cache_a)) &&
           (exist?(@cache_n) &&  File.ctime(@path) < File.ctime(@cache_n))
  end

  def make_table
    Logger::log(Logger::INFO,
		"Making index table for dictionary \`%s\'...", @path)

    @okuri_ari_table = []
    @okuri_nasi_table = []
    for line in @file
      if line == OKURI_ARI_LABEL
	@okuri_ari_table.push(@file.pos)
	break
      end
    end
    for line in @file
      if line == OKURI_NASI_LABEL
	@okuri_nasi_table.push(@file.pos)
	break
      else
	@okuri_ari_table.push(@file.pos)
      end
    end
    @okuri_ari_table.pop
    @okuri_ari_table.reverse!
    for line in @file
      @okuri_nasi_table.push(@file.pos)
    end
    @okuri_nasi_table.pop
    
    Logger::log(Logger::INFO, "done.")

    unless @nocache
      write_cache(@okuri_ari_table, @cache_a)
      write_cache(@okuri_nasi_table, @cache_n)
    end
  end
  
  def write_cache(table, file)
    Logger::log(Logger::NOTICE, "Writing cache file \`%s\'...", file)

    f = nil
    begin
      f = open(file, "w")
      f.write(table.pack("i*"))
    rescue
      Logger::log(Logger::WARNING, "failed to write cache file \`%s\'.", file)
    ensure
      f.close if f
    end
    Logger::log(Logger::NOTICE, "done.")
  end
  
  def read_cache(file)
    Logger::log(Logger::INFO, "Reading cache file \`%s\'...", file)

    cache = nil
    open(file) do |f|
      cache = f.read.unpack("i*")
    end

    Logger::log(Logger::INFO, "done")

    return cache
  end
  
  def search(kana)
    @search.call(kana + " ")
  end

  private
  def search_rb(kana)
    if kana =~ @okuri_ari_regexp
      table = @okuri_ari_table
    else
      table = @okuri_nasi_table
    end
    
    left = 0
    right = table.length - 1
    while left <= right
      pos = (left + right) / 2

      @file.seek(table[pos], 0)
      buff = @file.readline
      case buff[0, kana.length] <=> kana
      when 0
	return buff[kana.length + 1 .. -3].split("/")
      when 1
	right = pos - 1
      when -1
	left = pos + 1
      end
    end
    
    return []
  end

  def to_s
    format('#<SKKDic: path="%s", cache=["%s", "%s"]>',
	   @path, @cache_a, @cache_n)
  end

  def self.create(path, options, config)
    SKKDic.new(path, config.skk_cache_dir, config.skk_no_cache)
  end
end

### skkserv/skkdic.rb ends here
