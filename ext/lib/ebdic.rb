### skkserv/ebdic.rb --- rskkserv module for EB dictionary.

## Copyright (C) 2000,2001  YAMASHITA Junji

## Author:	YAMASHITA Junji <ysjj@unixuser.org>
## Version:	1.1

## This file is part of rskkserv.

## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation; either version 2, or (at
## your option) any later version.

## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.

### Code:

begin
  require "eb"
rescue LoadError
  Logger::log(Logger::INFO, "failed to load eb")
end

require "skkserv/logger"

# ddskk/skk-vars.el の skk-lookup-option-alist 変数を参考にした。
module EPWAgent
  GAIJI = "<?>"

  def gaiji_nasi?(str)
    str.index(GAIJI).nil?
  end

  def subbook(book, subbook_)
    if subbook_
      subbook = subbook_.upcase
      unless self.support_subbook.include?(subbook)
        raise "#{self}: #{subbook_}: unsupported subbook"
      end
    else
      subbook = self.default_subbook
    end

    book.subbook_list.each do |n|
      return n if book.directory(n).upcase == subbook
    end

    raise "#{subbook}: subbook not found"
  end

  def support_subbook
    [default_subbook]
  end

  module_function
  def find(book)
    agents = constants.map {|m| const_get(m)}.select {|m| m.respond_to?(:support_subbook)};

    book.subbook_list.map {|n| book.directory(n).upcase}.each do |subbook|
      agents.each do |m|
        return m if m.support_subbook.include?(subbook)
      end
    end

    return nil
  end

  # 凡例:
  # "検索語"
  #   => "見出し"
  #   => "変換候補1", "変換候補2", ...

  # KOUJIEN: 広辞苑 第四版
  # ・制限事項
  # (1) 外字を含む単語は変換候補に含めない。
  # (2) 送り仮名には対応していない。
  module KOUJIEN
    extend EPWAgent

    # 例:
    # "あーとまん"
    #	=> "アートマン【<?>tman 梵】"
    #	=> "アートマン", "梵"
    # "あお"
    #	=> あお【青】アヲ", "あお【襖】アヲ"
    #	=> "青", "襖"
    # "うぃ"
    #	=> "ウィ【oui フランス】"
    #	=> "ウィ", "oui", "フランス"
    # "でんかいこうかとらんじすたー"
    #   => "でんかい‐こうか‐トランジスター【電界効果―】"
    #   => "電界効果トランジスター"
    # "でんしすぴんきょうめい"
    #   => "でんし‐スピン‐きょうめい【電子―共鳴】"
    #   => "電子スピン共鳴"
    # "でんしめーる"
    #   => "でんし‐メール【電子―】"
    #   => "電子メール"
    # "とらのいをかるきつね"
    #   => "○虎の威を借る狐"
    #   => "虎の威を借る狐"
    # "のーべるしょう"
    #	=> "ノーベル‐しょう【―賞】‥シヤウ"
    #	=> "ノーベル賞"
    # "はしる"
    #   => "はし・る【走る・奔る】"
    #   => "走る", "奔る"
    # "びたみん"
    #   => "ビタミン【Vitamin ドイツ・vitamine イギリス】"
    #   => "ビタミン", "Vitamin", "ドイツ", "vitamine", "イギリス",
    # "やんわり"
    #   => "やんわり　ヤンハリ"
    #   =>
    # "ゆないてっどすてーつおぶあめりか"
    #	=> "ユナイテッド‐ステーツ‐オブ‐アメリカ【United States of America】"
    #	=> "United States of America"
    # "よーろっぱ"
    #	=> "ヨーロッパ【Europa ポルトガル・オランダ・欧羅巴】"
    #	=> "ヨーロッパ", "Europa", "ポルトガル", "オランダ", "欧羅巴"
    # "わしんとん"
    #	=> "ワシントン【Washington】", "ワシントン【Washington・華盛頓】"
    #	=> "ワシントン", Washington", "ワシントン", "Washington", "華盛頓"
    MATCH_REGEXP = /\A○?([^　【]+)(【([^】]+)】)?/e
    WORD_LANG_REGEXP = /([ .0-9<=>?A-Za-z]+) ([ーァ-ン梵]+)/e

    MIDPOINT_EUCJP = "\xa1\xa6" # "・"
    DASH_EUCJP = "\xa1\xbd"	# "―"
    HYPHEN_EUCJP = "\xa1\xbe"	# "‐"
    
    STEM_DELIMITER_EUCJP = MIDPOINT_EUCJP
    WORD_DELIMITER_EUCJP = HYPHEN_EUCJP
    SUBST_CHAR_EUCJP = DASH_EUCJP

    module_function
    def format(kana, candidates)
      result = []

      candidates.each do |e|
	MATCH_REGEXP =~ e

	g1,g2 = $1,$3

	g1.gsub!(STEM_DELIMITER_EUCJP, "")
	words = g1.split(WORD_DELIMITER_EUCJP)

	if words.length == 1 and g1 != kana and gaiji_nasi?(g1)
	  result.push(g1)
	end

	if g2
	  g2.split(MIDPOINT_EUCJP).each do |e|
	    format_sub(result, words, e)
	  end
	end
      end

      result
    end

    def format_sub(result, substs, candidate)
      WORD_LANG_REGEXP =~ candidate

      if $1
	result.push($1) if gaiji_nasi?($1)
	word = $2
      else
	word = candidate
      end

      return unless gaiji_nasi?(word)

      word.sub!(SUBST_CHAR_EUCJP) do
	if $`.empty?
	  substs[0]
	elsif substs[2] and $'.empty?
	  substs[2]
	else
	  substs[1]
	end
      end

      result.push(word)
    end

    def support_subbook
      [default_subbook, "KOJIEN"]
    end

    def default_subbook
      "KOUJIEN"
    end
  end

  # MYPAEDIA-fpw
  module MYPAEDIA
    extend EPWAgent

    # 例:
    # "あーとまん"
    #	=> "アートマン (<?>tman)"
    #	=> "アートマン"
    # "おわせ"
    #	=> "尾鷲 [おわせ] (市)"
    #	=> "尾鷲"
    # "からす"
    #	=> "カラス (Maria Callas)",
    #	   "カラス (烏) [カラス]",
    #	   "香良洲 [からす] (町)"
    #	=> "カラス", "Maria Callas", "カラス", "烏", "香良洲"
    # "すし"
    #   => "すし (鮓/鮨) [すし]"
    #   => "鮓", "鮨"
    # "におい"
    #   => "匂い/臭い [におい]"
    #   => "匂い", "臭い"
    # "のーべるしょう"
    #	=> "ノーベル賞 [ノーベルしょう]"
    #	=> "ノーベル賞"
    # "よーろっぱ"
    #	=> "ヨーロッパ (Europe)"
    #	=> "ヨーロッパ", "Europe"
    # "ししざ"
    #  => "しし (獅子) 座 [ししざ]"
    #  => "しし座", "獅子座"
    MATCH_REGEXP = /\A([^ ]+)( +\(([^\)]+)\) *([^ ]+)?)?/

    module_function
    def format(kana, candidates)
      result = []

      candidates.each do |e|
	e.sub!(/\[.+$/, "")
	MATCH_REGEXP =~ e
	r = []
	format_sub(r, $1) if $1 != kana
	format_sub(r, $3) if $3
	r.each {|s| s << $4} if $4
	result.concat(r)
      end

      result
    end

    def format_sub(result, candidate)
      candidate.split("/").each do |v|
	result.push(v) if gaiji_nasi?(v)
      end
    end

    def default_subbook
      "MYPAEDIA"
    end
  end

  module WDIC
    extend EPWAgent

    module_function
    def format(kana, candidates)
      candidates
    end

    def default_subbook
      "WDIC"
    end
  end
end

class EBDic
  def initialize(path, mod = nil, subbook = nil)
    @book = new_book(path)
    @formatter = get_formatter(mod)

    @book.subbook = @formatter.subbook(@book, subbook)
  end

  def search(kana)
#    Logger::log(Logger::DEBUG, "search: \"%s\", book: %s", kana, @book)
    begin
      candidates = if kana[-1] == ?* and @book.search_available?
		     kana2 = kana[0..-2]
		     @book.search2(kana2)
		   elsif kana[0] == ?* and @book.endsearch_available?
		     kana2 = kana[1..-1]
		     @book.endsearch2(kana2)
		   else
		     kana2 = kana
		     @book.exactsearch2(kana)
		   end
      result = @formatter.format(kana2, candidates.collect {|a| a[1]})
    rescue RuntimeError
      raise if $!.to_s != "fail searching"
      result = []
    end

#    Logger::log(Logger::DEBUG, "candidates: \"%s\"", result.join(","))
    result
  end

  def to_s
    format('#<EBDic: path="%s", directory="%s", title="%s">',
	   @book.path, @book.directory, @book.title)
  end

  def self.create(path, options, config)
    return EBDic.new(path, options["module"], options["subbook"])
  end

  private
  def new_book(path)
    result = EB::Book.new

    begin
      result.bind(path)
    rescue RuntimeError
      raise "#{path}: book not found"
    end

    result
  end

  def get_formatter(mod)
    unless mod
      result = EPWAgent.find(@book)
      raise "#{@book.path}: Not found module for" unless result
      return result
    end

    m = mod.upcase
    raise "#{mod}: Unknown module" unless EPWAgent.constants.include?(m)
    return EPWAgent.const_get(m)
  end
end

if __FILE__ == $0
  print EBDic.new("/opt/epwing/koujien", "KOUJIEN").search("あお").join("/"), "\n"
end

### skkserv/ebdic.rb ends here
