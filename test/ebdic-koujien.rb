#### test/ebdic-koujien.rb -- unit test for ebdic module, using KOUJIEN

require 'test/ebdic-common'

class TestEBDicKoujien <TestEBDicCommon
  def setup
    super("/opt/epwing/koujien")
  end

  def test_search_not_found
    check([""], search("ほげ"))
    check([""], search("\001\001"))
    check([""], search("やんわり"))
  end

  def test_search
    check(["アートマン", "梵"], search("あーとまん"))
    check(["青", "襖"], search("あお"))
    check(["ウィ", "oui", "フランス"], search("うぃ"))
    check(["電界効果トランジスター"], search("でんかいこうかとらんじすたー"))
    check(["電子スピン共鳴"], search("でんしすぴんきょうめい"))
    check(["電子メール"], search("でんしめーる"))
    check(["虎の威を借る狐"], search("とらのいをかるきつね"))
    check(["ノーベル賞"], search("のーべるしょう"))
    check(["任", "牧", "巻き", "巻", "薪", "真木", "槙", "真木", "マキ", "maquis", "フランス"],
	  search("まき"))
    check(["United States of America"],
	  search("ゆないてっどすてーつおぶあめりか"))
    check(["ヨーロッパ", "Europa", "ポルトガル", "オランダ", "欧羅巴"],
	  search("よーろっぱ"))
    check(["ワシントン", "Washington", "ワシントン", "Washington", "華盛頓"],
	  search("わしんとん"))
    check(["走る", "奔る"], search("はしる"))
  end

  def test_wildcard_not_found
    check([""], search("*"))
  end

  def test_wildcard
    check(["狐", "九尾の狐", "虎の威を借る狐"], search("*きつね"))
    check(["竹馬の友"], search("ちくばの*"))
  end
end

if __FILE__ == $0
  require 'test/unit/ui/console/testrunner'
  Test::Unit::UI::Console::TestRunner.run(TestEBDicKoujien.suite)
end

# test/ebdic-koujien.rb ends here
