### test/ebdic-wdic.rb -- unit test for ebdic module, using WDIC

require 'test/ebdic-common'

class TestEBDicWDic <TestEBDicCommon
  def setup
    super("/opt/epwing/wdic", "WDIC")
  end

  def test_search
    check([""], search("じゅげむ"))
    check([""], search("\001\001"))

    check(["はにゃーん", "はにゃ〜ん"], search("はにゃーん"))
  end

  def tear_down
  end
end

if __FILE__ == $0
  require 'runit/cui/testrunner'
  RUNIT::CUI::TestRunner.run(TestEBDicWDic.suite)
end

# test/ebdic-wdic.rb ends here
