### test/ebdic-common.rb -- common route for unit test of ebdic modules

require 'skkserv/ebdic.rb'
require 'test/unit/testcase'

$stdout.sync = true

class TestEBDicCommon <Test::Unit::TestCase
  def setup(path, mod = nil, subbook = nil)
    @path = path
    @ebdic = EBDic.new(@path, mod, subbook)
  end

  def join(arg)
    arg.join(",")
  end

  def search(kana)
    @ebdic.search(kana)
  end

  def check(expect, result)
    remove_dup(result)
    assert_equal(join(expect), join(result))
  end

  private
  def remove_dup(ary)
    return if ary.length % 2 == 1

    h = ary.length / 2
    a = ary[0..(h-1)]
    b = ary[h..-1]
    ary.slice!(0..(h-1)) if a == b
  end
end

### test/ebdic-common.rb ends here
