### test/ebdic.rb -- unit test for ebdic module, using KOUJIEN/MYPAEDIA/WDIC

require 'skkserv/ebdic.rb'
require 'test/unit/testcase'
require 'test/unit/testsuite'

$stdout.sync = true

class TestEBDic <Test::Unit::TestSuite
  def self.suite
    testsuite = TestEBDic.new 

    testsuite << TestEBDicError.suite

    load 'test/ebdic-koujien.rb'
    testsuite << TestEBDicKoujien.suite

    load 'test/ebdic-mypaedia.rb'
    testsuite << TestEBDicMypaedia.suite

    load 'test/ebdic-wdic.rb'
    testsuite << TestEBDicWDic.suite

    testsuite
  end

  class TestEBDicError <Test::Unit::TestCase
    def test_book_not_found
      e = assert_raises(RuntimeError) do
        EBDic.new("/opt/epwing")
      end
      assert_equal("/opt/epwing: book not found", e.message)
    end

    def test_unknown_module
      e = assert_raises(RuntimeError) do
        EBDic.new("/opt/epwing/koujien", "HOGE")
      end
      assert_equal("HOGE: Unknown module", e.message)
    end

    def test_unsupported_subbook
      e = assert_raises(RuntimeError) do
        EBDic.new("/opt/epwing/koujien", "KOUJIEN", "xxx")
      end
      assert_match(/KOUJIEN: xxx: unsupported subbook$/, e.message)
    end

    def test_subbook_not_found
      e = assert_raises(RuntimeError) do
        EBDic.new("/opt/epwing/mypaedia", "KOUJIEN", "KOJIEN")
      end
      assert_equal("KOJIEN: subbook not found", e.message)
    end

    def test_not_found_module_for
      e = assert_raises(RuntimeError) do
        EBDic.new("/opt/epwing/chujiten")
      end
      assert_equal("/opt/epwing/chujiten: Not found module for", e.message)
    end
  end
end

if __FILE__ == $0
  require 'test/unit/ui/console/testrunner'
  Test::Unit::UI::Console::TestRunner.run(TestEBDic.suite)
end

# test/ebdic.rb ends here
