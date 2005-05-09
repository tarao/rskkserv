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
    assert(@skkdic.search("¤Û¤²").empty?)
  end

  def test_lookup_okuri_ari_success
    assert_equal("½À;Æð;ÏÂ;ÌðÄ¥", @skkdic.search("¤ä¤Ïr").join(";"))
    assert_equal("ÀË", @skkdic.search("¤òs").join(";"))
    assert_equal("Íá", @skkdic.search("¤¢b").join(";"))
  end

  def test_lookup_okuru_nasi_failure
    assert(@skkdic.search("¤Û¤²r").empty?)
  end

  def test_lookup_okuri_nasi_success
    assert_equal("ÀÄ,Áó,ÊË", @skkdic.search("¤¢¤ª").join(","))
    assert_equal("¼ÙÇÏÂæ¹ñ,¼ÙÇÏçÊ¹ñ;µì»úº®ÞÂ",
		 @skkdic.search("¤ä¤Þ¤¿¤¤¤³¤¯").join(","))
    assert_equal("¡ª,´¶Ã²Éä", @skkdic.search("!").join(","))
  end

  def tear_down
  end
end

if __FILE__ == $0
  require "test/unit/ui/console/testrunner"
  Test::Unit::UI::Console::TestRunner.run(TestCDBDic.suite)
end

# test/cdbdic.rb ends here
