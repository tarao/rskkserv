### test/ebdic-mypaedia.rb -- unit test for ebdic module, using MYPAEDIA

require 'test/ebdic-common'

class TestEBDicMypaedia <TestEBDicCommon
  def setup
    super("/opt/epwing/mypaedia", "MYPAEDIA")
  end

  def test_search
    check([""], search("ほげ"))
    check([""], search("\001\001"))

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

  def tear_down
  end
end

if __FILE__ == $0
  require 'runit/cui/testrunner'
  RUNIT::CUI::TestRunner.run(TestEBDicMypaedia.suite)
end

# test/ebdic-mypaedia.rb ends here
