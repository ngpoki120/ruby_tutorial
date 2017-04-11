# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

require 'nokogiri'
require 'open-uri'
require 'cgi'

english_regex = /\w/
japanese_regex = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
mode = 0

while true do

  puts "Please enter a word."
  word = gets.chop
  word = word.encode("utf-8")

  if word =~ english_regex then
    word_uri = word
    mode = 0
  elsif word =~ japanese_regex then
    word_uri = CGI.escape(word)
    mode = 1
  else
    puts "Unknown Language.\n\n"
    next
  end

#URL非公開
  doc=Nokogiri::HTML(open("  URL  #{word_uri}"))
  data=doc.css("td.content-explanation").inner_html
  unless mode then
    puts "--Meaning of #{word}"
    if data.empty? then
      puts "#No result\n\n"
    else
      puts "#{data}\n\n"
    end
  else
    puts "--#{word}の英訳"
    if data.empty? then
      puts "#結果なし"
    else
      puts "#{data}\n\n"
    end
  end

end
