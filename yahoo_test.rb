#! ruby -Ku

require "cgi"
require "open-uri"
require "pp"

require "rubygems"
require "json"

text = "２６日午後７時４０分ごろ、京都府長岡京市長岡の阪急京都線の踏切近くで、線路上にいた同市に住む男性（２９）が、河原町発梅田行き準急電車にはねられ、全身を強く打って即死した。運転士が警笛を鳴らしても退避しなかったといい、向日町署は自殺の可能性があるとみて調べている。　阪急によると、この電車は現場に８分間停車。後続など上下計２９本が３〜７分遅れとなり、約１万２５００人に影響した。"
text = "本日は晴天なり。"
text = "ウマのゲノム解読、医学に応用も　ＪＲＡなど国際チーム"

url  = "http://localhost:8080/yahoo-keyphrase/extract?text1=" + CGI.escape(text)
json = open(url) { |io| io.read }
obj  = JSON.parse(json)
pp obj
