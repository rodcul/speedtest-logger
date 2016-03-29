require "net/http"

output = `speedtest-cli --simple`
# output = "Ping: 246.466 ms\nDownload: 2.69 Mbit/s\nUpload: 1.03 Mbit/s\n"
ping = output[(output.index('Ping: ') + 6)..(output.index('ms')-2)]
download = output[(output.index('Download: ') + 10)..(output.index('Mbit')-2)]
upload = output[(output.index('Upload: ') + 8)..(output.length - 9)]

# OSX vs. Linux
# ssid = (`iwgetid -r`).strip
ssid = (`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`).strip

uri = URI('http://speedy-cnx.herokuapp.com/speedtests')

req = Net::HTTP::Post.new(uri)
req.set_form_data({ping: ping, upload: upload, download: download, ssid: ssid})

res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

case res
when Net::HTTPSuccess, Net::HTTPRedirection
  # OK
else
  res.value
end
