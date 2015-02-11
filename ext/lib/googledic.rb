# coding: utf-8
require 'skkserv/logger'
require 'net/http'
require 'json'
require 'uri'

class GOOGLEDic
  def initialize(path, mod = nil, subbook = nil)
    @path = path
    @cache = Hash.new([])
    Logger::log(Logger::DEBUG, "Initiarized: %s", path)
    return true
  end

  def search(kana)
    if kana[-1].ascii_only? then
      Logger::log(Logger::DEBUG, "last char is %s", kana[-1])
      return []
    end
    if @cache[kana] != []
      return @cache[kana]
    end
    begin
      params = "langpair=ja-Hira|ja&text=" + URI.escape(kana + ',')
      Logger::log(Logger::DEBUG, "params: %s", params)
      json = Net::HTTP.get @path, "/transliterate?" + params
      Logger::log(Logger::DEBUG, "json: %s", json)
      tmp = JSON.load(json)
      tmp2 = tmp[0][1]
      result = []
      for i in tmp2 do
        tmp3 = i.force_encoding("ASCII-8BIT")
        Logger::log(Logger::DEBUG, "encode: %s", tmp3.encoding)
        result.push(tmp3)
      end
      @cache[kana] = result
    rescue
      raise if $!.to_s != "fail searching"
      result = []
    end
    # result.reverse!
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
