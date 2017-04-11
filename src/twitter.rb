# -*- coding: utf-8 -*-
require "twitter"
require "natto"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "h0oQpJ62UmzuYjOmevNOPsqyK"
  config.consumer_secret     = "DWatjDTfv4vHTyBrtH5a23T5yL9fY6OqlphWbbY8yMTGqD7nLn"
  config.access_token        = "722605093-utmypt1xin58wG620W9scEzm7vy7AJTHBkmlfSRM"
  config.access_token_secret = "En8ODjPcbQ0ifWfGJqDQ0y3zrWTpfVhcYiDU5REAe6Obr"
end

natto = Natto::MeCab.new
data = []
tweets = []

client.search(ARGV[0].encode("UTF-8")).take(500).each do |tweet|
  unless tweet.text=~/\w/
    tweets.push(tweet.text)
  end
end

for t in tweets do
  natto.parse(t) do |n|
    case n.posid
    when 10, 36, 38, 46, 67 then
      data.push(n.surface)
    end
  end
end

dict = {}

for d in data do
  if dict[d].nil?
    dict[d] = 1
  else
    dict[d] = dict[d] + 1
  end
end

dict = dict.sort_by{|key,val| -val}[0..9]

file = File.open("mecab.txt","w")
dict.each{ |k,v|
  file.puts "#{k}, #{v}"
}
