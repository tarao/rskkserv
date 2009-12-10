### skkserv/skkservdic.rb --- rskkserv module for relaying to skkserv.

## Copyright (C) 2005  YAMASHITA Junji

## Author:	YAMASHITA Junji <ysjj@unixuser.org>
## Version:	0.1

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

## 2005/09/25:
# Created

### Code:

require "uri"

require "skkserv/logger"
require "skkserv/nulldic"

class SKKSERVDic <NULLDic
  def initialize(con)
    @con = con
  end

  def search(kana)
    result = []
    @con.get {|io|
      io.syswrite(SKKServer::CLIENT_REQUEST.chr + kana + " \n")
      r, s = [io], ""
      while IO.select(r)
        s << io.sysread(SKKServer::BUFSIZE)
        break if s[-1] == ?\n
      end
      result = s[2..-3].split("/") if s[0] == SKKServer::SERVER_FOUND
    }
    return result
  end

  def reload
    @con.reset
  end

  private

  module Connection
    def get_internal
      @con = connect if @con.nil?
      yield @con
      disconnect unless keep_alive?
    end

    def reset
      disconnect unless @con.nil? || @con.closed?
      @con = nil
    end

    def keep_alive?
      true
    end

    def disconnect
      @con.close
    end
  end

  class TCP
    include Connection

    def initialize(host, port)
      @host, @port = host, port
    end

    def get(&block)
      begin
        get_internal &block
      rescue SystemCallError => ex
        raise ex
      rescue => ex
        raise ex
      end
    end

    def connect
      TCPSocket.new(@host, @port)
    end

    def disconnect
      @con.shutdown
      @con.close
    end

    def self.create(uri, options)
      host = options["host"] || uri.host
      port = options["port"] || uri.port || SKKServer::DEFAULT_PORT
      self.new(host, port)
    end
  end

  class PIPE
    include Connection

    def initialize(path, args)
      @path, @args = path, args
    end

    def get(&block)
      begin
        get_internal &block
      rescue SystemCallError => ex
        raise ex
      rescue => ex
        raise ex
      end
    end

    def connect
      IO.popen(@path + " " + @args, "w+")
    end

    def self.create(uri, options)
      path = options["command"] || uri.path
      args = options["args"] || (uri.query || "").gsub(/&/, " ")
      self.new(path, args)
    end
  end

  def self.create(path, options, config)
    uri = URI.parse(path)
    type = (options["connection"] || "TCP").upcase
    self.new(self.const_get(type).create(uri, options))
  end
end

### skkserv/skkservdic.rb ends here
