### skkserv/conf.rb --- rskkserv module for configuration

## Copyright (C) 2003  YAMASHITA Junji

## Author: YAMASHITA Junji <ysjj@unixuser.org>

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

class Conf
  def initialize(path)
    @path = path

    OPTIONS.each {|k,v|
      __send__("#{k}=", v.defval)
    }

    File.open(@path) do |f|
      parse(f)
    end
  end

  private

  OptionValue = Struct.new("OptionValue", :defval, :xproc)

  OPTIONS = {
      "port" => OptionValue.new(1178, :str2int),
      "host" => OptionValue.new(nil, :str2str),
      "daemon" => OptionValue.new(true, :str2bool),
      "max_clients" => OptionValue.new(128, :str2int),
      "tcpwrap" => OptionValue.new(true, :str2bool),
      "pid_file" => OptionValue.new("/var/run/rskkserv.pid", :str2str),
      "log_level" => OptionValue.new(:INFO, :str2sym),
      "log_file" => OptionValue.new("/var/log/rskkserv.log", :str2str),
      "skk_no_cache" => OptionValue.new(false, :str2bool),
      "skk_cache_dir" => OptionValue.new("/var/cache/rskkserv", :str2str),
  }

  (OPTIONS.keys | ["dic"]).each do |k|
    attr_accessor k
    public k
  end

  def parse(file)
    file.each_line do |l|
      next if l[0] == ?# or /^\s*$/ =~ l
      unless (/^([^=]+)=(.*)$/ =~ l)
        STDERR.print "parse failed: #{l}\n"
        next
      end
      key, val = $1.strip, $2.strip
      key.gsub!(/\s+/, "_")
      key.downcase!

      if (key == "dic")
        @dic = [] if @dic.nil?
        def_options(val)
        @dic.push(val)
      elsif (@dic != nil)
        @dic[-1].options[key] = val
      else
        raise "#{key}=#{val}: unknown parameter" unless OPTIONS.key?(key)
        __send__("#{key}=", __send__(OPTIONS[key].xproc, val))
      end
    end
  end

  def str2int(val)
    val.to_i
  end

  def str2bool(val)
    if (val =~ /^(on|true)$/i)
      return true
    elsif (val =~ /^(off|false)$/i)
      return false
    end
    raise "boolean value required"
  end

  def str2str(val)
    val
  end

  def str2sym(val)
    val.upcase.intern
  end

  def def_options(obj)
    obj.instance_eval {
      @options = Hash.new
    }
    def obj.options
      @options
    end
  end
end

### skkserv/conf.rb ends here
