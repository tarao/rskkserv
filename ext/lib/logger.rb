### skkserv/logger.rb --- subroutine for logging

## Copyright (C) 2001  YAMASHITA Junji

## Author:	YAMASHITA Junji <ysjj@unixuser.org>
## Version:	0.3

## This file is part of rskkserv.

## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation; either version 2, or (at
## your option) any later version.

## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.

### Code:

require "thread"

class Logger
  NOLOG   = -1
  EMERG   = 0
  ALERT   = 1
  CRIT    = 2
  ERR     = 3
  WARNING = 4
  NOTICE  = 5
  INFO    = 6
  DEBUG   = 7

  @@level = NOLOG
  @@verbose = false
  @@filename = "/dev/stdout"
  @@time_format = "%m/%d:%H:%M:%S"

  @@mutex = Mutex.new

  def self.log(level, format, *args)
    printf(format + "\n", *args) if @@verbose && level < DEBUG
    return if level > @@level

    @@mutex.synchronize do
      File.open(@@filename, "a") do |f|
	f.printf("%s: ", Time.now.strftime(@@time_format))
	f.printf(format, *args)
	f.printf("\n")
      end
    end
  end

  def self.level
    @@level
  end

  def self.level=(new_level)
    if new_level < NOLOG or DEBUG < new_level
      raise ArgumentError, "invalid level: #{new_level}"
    end

    @@level = new_level
  end

  def self.verbose
    @@verbose
  end

  def self.verbose=(verbose)
    @@verbose = verbose
  end

  def self.filename=(new_filename)
    @@filename = new_filename
  end

  def self.filename
    @@filename
  end
end

### skkserv/logger.rb ends here
