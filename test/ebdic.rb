### test/ebdic.rb -- unit test for ebdic module, using KOUJIEN/MYPAEDIA/WDIC

require 'skkserv/ebdic.rb'
require 'runit/testcase'

$stdout.sync = true

class TestEBDicNoBook <RUNIT::TestCase
  def test_nobook
    assert_exception(RuntimeError) do
      EBDic.new("/opt", "HOGE")
    end
  end
end

class TestEBDic <RUNIT::TestSuite
  def self.suite
    testsuite = TestEBDic.new 

    testsuite.add_test(TestEBDicNoBook.suite)

    load 'test/ebdic-koujien.rb'
    testsuite.add_test(TestEBDicKoujien.suite)

    load 'test/ebdic-mypaedia.rb'
    testsuite.add_test(TestEBDicMypaedia.suite)

    load 'test/ebdic-wdic.rb'
    testsuite.add_test(TestEBDicWDic.suite)

    testsuite
  end
end

if __FILE__ == $0
  require 'runit/cui/testrunner'
  RUNIT::CUI::TestRunner.run(TestEBDic.suite)
end

# test/ebdic.rb ends here
