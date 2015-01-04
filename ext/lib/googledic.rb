# coding: utf-8
require 'skkserv/logger'
require 'net/http'
require 'json'
require 'uri'

class GOOGLEDic
  def initialize(path, mod = nil, subbook = nil)
    @path = path
    Logger::log(Logger::DEBUG, "Initiarized: %s", path)
    return true
  end

  def search(kana)
    begin
      params = "langpair=ja-Hira|ja&text=" + URI.escape(kana + ',')
      Logger::log(Logger::DEBUG, "params: %s", params)
      json = Net::HTTP.get "www.google.com", "/transliterate?" + params
      Logger::log(Logger::DEBUG, "json: %s", json)
      tmp = JSON.load(json)
      tmp2 = tmp[0][1]
      result = []
      for i in tmp2 do
        tmp3 = i.force_encoding("ASCII-8BIT")
        Logger::log(Logger::DEBUG, "encode: %s", tmp3.encoding)
        result.push(tmp3)
      end
    rescue
      raise if $!.to_s != "fail searching"
      result = []
    end
    result
  end

  def to_s
    format('#<GOOGLEDic: path="%s">', @path)
  end

  def self.create(path, options, config)
    Logger::log(Logger::DEBUG, "create: %s", path)
    GOOGLEDic.new(path)
  end

end

if __FILE__ == $0
end

### skkserv/googledic.rb ends here
