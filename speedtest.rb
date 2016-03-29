require "addressable/uri"
require 'open-uri'

# output = `speedtest-cli --simple`
output = "Ping: 246.466 ms\nDownload: 2.69 Mbit/s\nUpload: 1.03 Mbit/s\n"
ping = output[(output.index('Ping: ') + 6)..(output.index('ms')-2)]
download = output[(output.index('Download: ') + 10)..(output.index('Mbit')-2)]
upload = output[(output.index('Upload: ') + 8)..(output.length - 9)]
ssid = (`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`).strip

uri = Addressable::URI.new
uri.query_values = {ping: ping, upload: upload, download: download, ssid: ssid}
p uri.query

puts 'http://requestb.in/test?' + uri.query
# response = open(URI.join('http://requestb.in/sjj8dfsj' , 'test'))
# response.each_line { |f| f.each_line {|line| p line} }
