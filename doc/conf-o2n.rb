#!/usr/bin/ruby
# conf-o2n.rb -- convert old sytle rskkserv.conf to new style.
#
# usage: conf-o2n.rb old-rskkserv.conf [new-rskkserv.conf]
#
# Copyright 2003 YAMASHITA Junji <ysjj@unixuser.org>
# License: GPL
# Created: Sat, 22 Nov 2003 15:39:58 +0900

old_conf_path = ARGV[0]
new_conf_path = ARGV[1] || ARGV[0] + ".new"

load old_conf_path

File.open(new_conf_path, "w") do |new_conf|
  new_conf.write <<EOH
# #{new_conf_path} -- rskkserv configuration file
# This is auto generated file from #{old_conf_path}
# Please replace #{old_conf_path} with #{new_conf_path}
# for rskkserv 2.95 or later.

EOH
  def each_module(m)
    m.constants.map {|v|
      m.const_get(v)
    }.select {|v|
      v.class == Module
    }.each do |v|
      yield v
    end
  end

  class << new_conf
    def set_if_def(m, old_var, new_var)
      if m.constants.include?(old_var)
        val = m.const_get(old_var)
        val = yield(val) if block_given?
        write("#{new_var} = #{val}\n")
      end
    end

    def global
      ["HOST", "PORT", "MAX_CLIENTS", "DAEMON", "TCPWRAP",
       "PID_FILE", "LOG_FILE"].each do |var|
        set_if_def(SKKServerConfig, var, var.downcase)
      end

      set_if_def(SKKServerConfig, "LOG_LEVEL", "log_level") do |v|
        v.to_s.downcase
      end
    end

    def skkdic
      return unless SKKServerConfig.constants.include?("SKKDic")

      skkdic = SKKServerConfig::SKKDic
      set_if_def(skkdic, "DICFILE", "dic") do |v|
        "skk:#{v}"
      end

      set_if_def(skkdic, "CACHEDIR", "skk cache dir")
      set_if_def(skkdic, "NOCACHE", "skk no cache")
      if skkdic.constants.include?("KCODE")
        write "# KCODE is obsoleted, ignored\n"
        if /shift_jis/i =~ skkdic.const_get("KCODE").to_s
          STDOUT.print "Warning: SKK-JISYO in Shift_JIS isn't supported" 
        end
      end

      each_module(skkdic) do |m|
        set_if_def(m, "DICFILE", "dic") do |v|
          "skk:#{v}"
        end
      end
    end

    def ebdic
      return unless SKKServerConfig.constants.include?("EBDic")

      write("# SUBDIC/SUBBOOK are redundant in most cases\n")
      each_module(SKKServerConfig::EBDic) do |m|
        set_if_def(m, "DICDIR", "dic") do |v|
          "eb:#{v}"
        end
        set_if_def(m, "SUBDIC", "    subbook")
        set_if_def(m, "SUBBOOK", "    subbook")
      end
    end
  end

  new_conf.global
  new_conf.write("\n")
  new_conf.skkdic
  new_conf.write("\n")
  new_conf.ebdic
end
