### skkserv/cdbdic.rb --- rskkserv module for skkdic in cdb.

## Copyright (C) 2005  YAMASHITA Junji

## Author:	YAMASHITA Junji <ysjj@unixuser.org>
## Version:	1.0

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

## 2005/05/04:
# Created

### Code:

require "skkserv/logger"

begin
  require "cdb"
rescue LoadError
  Logger::log(Logger::INFO, "%s: %s", $0, $!)
end


class CDBDic
  def initialize(path)
    if Module.const_defined?(:CDB)
      cdb = ::CDB.new(path)
      @search = proc {|kana| cdb[kana]}
    else
      file = File.open(path)
      @search = proc {|kana| CDBDic::CDB::get(file, 0, kana)}
    end
  end

  def search(kana)
    r = @search.call(kana)

    return r.nil? ? [] : r[1..-2].split('/')
  end

  def self.create(path, options, config)
    CDBDic.new(path)
  end

  # http://cr.yp.to/cdb.html
  # http://cr.yp.to/cdb/cdb.txt
  # http://www.unixuser.org/~euske/doc/cdbinternals/
  # http://www.unixuser.org/~euske/doc/cdbinternals/pycdb.py
  module CDB
    # These functions originated from sample implimentation in python 
    # written by Yusuke Shinyama.
    module_function

    def cdb_hash(s)
      s.unpack('C*').inject(5381) {|h,c| (((h << 5) + h) ^ c) & 0xffffffff}
    end

    def get(f, basepos, k)
      h = cdb_hash(k)

      f.sysseek(basepos + (h % 256) * (4+4))
      (bucketpos, ncells) = f.sysread(4+4).unpack('VV')
      return nil if ncells == 0

      start = (h >> 8) % ncells
      0.upto(ncells) {|i|
	f.sysseek(bucketpos + ((start+i) % ncells)*(4+4))
	(h1, p1) = f.sysread(4+4).unpack('VV')
	return nil if p1 == 0
	if (h1 == h)
	  f.sysseek(p1)
	  (klen, vlen) = f.sysread(4+4).unpack('VV')
	  k1 = f.sysread(klen)
	  v1 = f.sysread(vlen)
	  return v1 if k1 == k
	end
      }
      return nil
    end
  end
end

### skkserv/cdbdic.rb ends here
