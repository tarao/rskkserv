# test/skkserv.rb --- test unit for communicate skkserv.rb process

require 'runit/testcase'
require 'socket'

$stdout.sync = true

$skkserv_hostname = "localhost"
$skkserv_port = 21178
$skkserv_version = "2.95.1"
class SKKServTest <RUNIT::TestCase
  def setup
    @socket = TCPSocket.open($skkserv_hostname, $skkserv_port)
  end

  def client_end
    @socket.write("0") unless @socket.closed?
  end

  def test_client_request_success
    @socket.write("1¤®¤ª¤ó ")
    assert_equal("1/µÀ±à/µ¼²»/\n", @socket.sysread(1024))
    @socket.write("1¤¢¤ª ")
    assert_equal("1/ÀÄ/Áó/ÊË/ðÐ/²¨/\n", @socket.sysread(1024))
    @socket.write("1¤¢¤ª\n")
    assert_equal("1/ÀÄ/Áó/ÊË/ðÐ/²¨/\n", @socket.sysread(1024))
    @socket.write("10698585 ")
    assert_equal("1/ËÌ³¤Æ»¾ðÊóÂç³Ø @ ËÌ³¤Æ»¹¾ÊÌ»ÔÀ¾ÌîËÚ£µ£¹ÈÖÃÏ£²¹æ/\n",
		 @socket.sysread(1024))
    @socket.write("1¤ä¤Ïr ")
    assert_equal("1/½À/Æð/ÏÂ/ÌðÄ¥/\n", @socket.sysread(1024))
  end

  def test_client_request_failure
    @socket.write("1¤â¤² ")
    assert_equal("4¤â¤² ", @socket.sysread(1024))
    @socket.write("1¤Õ¤²\n")
    assert_equal("4¤Õ¤²\n", @socket.sysread(1024))
    @socket.write("1\001\001 ")
    assert_equal("4\001\001 ", @socket.sysread(1024))
  end

  def test_client_version
    @socket.write("2")
    assert_equal("rskkserv-#{$skkserv_version} ", @socket.sysread(1024))
    @socket.write("2hogemoge")
    assert_equal("rskkserv-#{$skkserv_version} ", @socket.sysread(1024))
  end

  def test_client_unknown
    @socket.write("9hoge")
  end

  def test_client_host
    @socket.write("3")
    assert_equal($skkserv_hostname + ":" << TCPSocket.getaddress($skkserv_hostname) << ": ", @socket.sysread(1024))
  end

  def test_request_after_end
    client_end
    assert_exception(EOFError) do
      @socket.sysread(1024)
    end
  end

  def tear_down
    client_end
    @socket.shutdown
    @socket.close
  end
end

if __FILE__ == $0
  require 'runit/cui/testrunner'
  RUNIT::CUI::TestRunner.run(SKKServTest.suite)
end

# test/skkserv.rb ends here
