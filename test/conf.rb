# test/conf.rb -- unit test for conf module,

require "skkserv/conf"
require "test/unit/testcase"
require "test/unit/testsuite"

$stdout.sync = true

class TestConf <Test::Unit::TestSuite
  def self.suite
    testsuite = TestConf.new
    testsuite.add_test(TestConfNormal.suite)

    testsuite
  end

  class TestConfNormal <Test::Unit::TestCase
    @@count = 0
    def setup
      @params = {
        "port" => 21178,
        "daemon" => false,
        "tcpwrap" => [false, "off"],
        "log_level" => [:DEBUG, "debug"],
        "log_file" => "test/var/rskkserv.log",
        "skk_no_cache" => false,
        "skk_cache_dir" => "test/var",
        "dic0" => "skk:/usr/share/skk/SKK-JISYO.L",
        "dic1" => "eb:/opt/epwing/koujien",
        "dic1 module" => "KOUJIEN",
        "dic1 subbook" => "koujien",
        "dic2" => "skk:/usr/share/skk/SKK-JISYO.zipcode",
      }
      @path = "test/conf/rskkserv.conf.#{$$}.#{@@count+=1}"
      File.open(@path, "w") {|f|
        f.print("# comment and blank lines\n\n  \n")
        f.print("port = #{@params["port"]}\n")
        f.print("# host is default \n")
        f.print("daemon = #{@params["daemon"]}\n")
        f.print("tcpwrap = #{@params["tcpwrap"][1]}\n")
        f.print("log level = #{@params["log_level"][1]}\n")
        f.print("log_file = #{@params["log_file"]}\n")
        f.print("# skk use cache is default\n")
        f.print("skk cache dir = #{@params["skk_cache_dir"]}\n")
        f.print("dic = #{@params["dic0"]}\n")
        f.print("dic = #{@params["dic1"]}\n")
        f.print("    module = #{@params["dic1 module"]}\n")
        f.print("    subbook = #{@params["dic1 subbook"]}\n")
        f.print("dic = #{@params["dic2"]}\n")
      }
      @conf = Conf.new(@path)
    end

    def teardown
      File.unlink(@path)
    end

    def test_simple_value
      assert_equal(@params["port"], @conf.port)
      assert_equal(@params["host"], @conf.host)
      assert_equal(@params["daemon"], @conf.daemon)
      assert_equal(@params["tcpwrap"][0], @conf.tcpwrap)
      assert_equal(@params["log_level"][0], @conf.log_level)
      assert_equal(@params["log_file"], @conf.log_file)
      assert_equal(@params["skk_no_cache"], @conf.skk_no_cache)
      assert_equal(@params["skk_cache_dir"], @conf.skk_cache_dir)
    end

    def test_dic
      assert_equal(3, @conf.dic.length)
      @conf.dic.each_with_index do |val,i|
        assert_equal(@params["dic#{i}"], val)
      end
      assert_equal(@params["dic1 module"], @conf.dic[1].options["module"])
      assert_equal(@params["dic1 subbook"], @conf.dic[1].options["subbook"])
    end

    def test_assign_fail
      assert_raises(NoMethodError) do # call private method
        @conf.port = 21178
      end
    end
  end
end

if __FILE__ == $0
  require 'test/unit/ui/console/testrunner'
  Test::Unit::UI::Console::TestRunner.run(TestConf.suite)
end

# test/conf.rb ends here
