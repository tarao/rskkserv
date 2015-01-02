# -*- ruby -*-

require "mkmf"

# guessing `rubylibdir' and `rubyarchdir'
prefix = "/usr/local"
if prefix == CONFIG["prefix"]
  rubylibdir = CONFIG["rubylibdir"]
  rubyarchdir = CONFIG["archdir"]
else
  rubylibdir = prefix + "/lib/ruby/" + CONFIG["MAJOR"] + "." + CONFIG["MINOR"]
  rubyarchdir = rubylibdir + "/" + CONFIG["arch"]
end

# override the guessed dir, if passed by args
rubylibdir = "guessed" if "guessed" != "guessed"
rubyarchdir = "guessed" if "guessed" != "guessed"

def create_depend(libdir, archdir)
  srcdir = File.dirname($0)
  open("depend", "w") do |f|
    f.print("rsslibdir = #{libdir}\n")
    f.print("rssarchdir = #{archdir}\n")
    f.print("rss-install: ")
    if (archdir == $archdir) and (libdir == $rubylibdir)
      f.print("install\n")
    elsif (archdir == $sitearchdir) and (libdir == $sitelibdir)
      f.print("site-install\n")
    else
      f.print("$(rssarchdir)$(target_prefix)/$(DLLIB)\n")
      f.print <<EOMF
$(rssarchdir)$(target_prefix)/$(DLLIB): $(DLLIB)
	@$(RUBY) -r fileutils -e 'FileUtils::makedirs(ARGV)' $(rsslibdir) $(rssarchdir)$(target_prefix)
	@$(RUBY) -r fileutils -e 'FileUtils::install(ARGV[0], ARGV[1], 0555, true)' $(DLLIB) $(rssarchdir)$(target_prefix)/$(DLLIB)
EOMF
     install_rb(f, "$(rsslibdir)$(target_prefix)", srcdir)
     f.print "\n"
    end
  end
end

create_depend(rubylibdir, rubyarchdir)

create_makefile("skkserv/skkdic")
