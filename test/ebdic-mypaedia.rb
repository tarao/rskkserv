### test/ebdic-mypaedia.rb -- unit test for ebdic module, using MYPAEDIA

require 'test/ebdic-common'

class TestEBDicMypaedia <TestEBDicCommon
  def setup
    super("/opt/epwing/mypaedia")
  end

  def test_search_not_found
    check([""], search("ほげ"))
    check([""], search("\001\001"))
  end

  def test_search
    check(["アートマン"], search("あーとまん"))
    check(["尾鷲"], search("おわせ"))
    check(["カラス", "Maria Callas", "カラス", "烏", "香良洲"],
	  search("からす"))
    check(["ヨーロッパ", "Europe"], search("よーろっぱ"))
    check(["マキ", "Maquis", "マキ", "牧", "巻", "薪"], search("まき"))
    check(["ノーベル賞"], search("のーべるしょう"))
    check(["鮓", "鮨"], search("すし"))
    check(["匂い", "臭い"], search("におい"))
    check(["しし座", "獅子座"], search("ししざ"))
  end
end

if __FILE__ == $0
  require 'test/unit/ui/console/testrunner'
  Test::Unit::UI::Console::TestRunner.run(TestEBDicMypaedia.suite)
end

# test/ebdic-mypaedia.rb ends here
