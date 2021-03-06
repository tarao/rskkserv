# test/skkdic.rb -- unit test for skkdic module,
#		    using SKK-JISYO.L (v1.30 2000/12/07 12:11:23)

require "skkserv/skkdic.rb"
require "test/unit/testcase"

$jisyo = "/usr/share/skk/SKK-JISYO.L"
$cachedir = "./test/var"
$nocache = nil

$stdout.sync = true

class TestSKKDic <Test::Unit::TestCase
  def setup
    @skkdic = SKKDic.new($jisyo, $cachedir, $nocache)
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
  Test::Unit::UI::Console::TestRunner.run(TestSKKDic.suite)
end

# test/skkdic.rb ends here
