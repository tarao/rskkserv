# test/skkdic.rb -- unit test for skkdic module,
#		    using SKK-JISYO.L (v1.30 2000/12/07 12:11:23)

require "runit/testcase"
require "skkserv/skkdic.rb"

$jisyo = "/usr/share/skk/SKK-JISYO.L"
$cachedir = "/var/lib/rskkserv"
$nocache = nil

$stdout.sync = true

class SKKDicTest <RUNIT::TestCase
  def setup
    @skkdic = SKKDic.new($jisyo, $cachedir, $nocache)
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
    assert_equal("ÀÄ;Áó;ÊË;ðÐ", @skkdic.search("¤¢¤ª").join(";"))
    assert_equal("¼ÙÇÏÂæ¹ñ;¼ÙÇÏÔå¹ñ;¼ÙÇÏçÊ¹ñ",
		 @skkdic.search("¤ä¤Þ¤¿¤¤¤³¤¯").join(";"))
    assert_equal("¡ª;´¶Ã²Éä", @skkdic.search("!").join(";"))
    assert_equal("¡¦", @skkdic.search("¥Æ¥ó").join(";"))
  end

  def tear_down
  end
end

if __FILE__ == $0
  require "runit/cui/testrunner"
  RUNIT::CUI::TestRunner.run(SKKDicTest.suite)
end

# test/skkdic.rb ends here
