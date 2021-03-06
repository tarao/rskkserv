# test/cdbdic.rb -- unit test for cdbdic module,
#		    using SKK-JISYO.L.cdb (skkdic-cdb 20040323-1 deb)

require "skkserv/cdbdic.rb"
require "test/unit/testcase"

$jisyo = "/usr/share/skk/SKK-JISYO.L.cdb"

$stdout.sync = true

class TestCDBDic <Test::Unit::TestCase
  def setup
    @skkdic = CDBDic.new($jisyo)
  end

  def test_lookup_okuru_ari_failure
    assert(@skkdic.search("ほげ").empty?)
  end

  def test_lookup_okuri_ari_success
    assert_equal("柔;軟;和;矢張", @skkdic.search("やはr").join(";"))
    assert_equal("惜", @skkdic.search("をs").join(";"))
    assert_equal("浴", @skkdic.search("あb").join(";"))
  end

  def test_lookup_okuru_nasi_failure
    assert(@skkdic.search("ほげr").empty?)
  end

  def test_lookup_okuri_nasi_success
    assert_equal("青,蒼,碧", @skkdic.search("あお").join(","))
    assert_equal("邪馬台国,邪馬臺国;旧字混淆",
		 @skkdic.search("やまたいこく").join(","))
    assert_equal("！,感嘆符", @skkdic.search("!").join(","))
  end

  def tear_down
  end
end

if __FILE__ == $0
  require "test/unit/ui/console/testrunner"
  Test::Unit::UI::Console::TestRunner.run(TestCDBDic.suite)
end

# test/cdbdic.rb ends here
