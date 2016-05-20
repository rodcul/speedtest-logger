require 'net/http'
require 'socket'
require 'logger'

logfile = File.open('/var/log/cronlog', 'a+')
logger = Logger.new(logfile)
logger.debug('Starting CRON')
logger.debug('Running speedtest')
output = `speedtest-cli --simple`

# output = "Ping: 246.466 ms\nDownload: 2.69 Mbit/s\nUpload: 1.03 Mbit/s\n"
ping = output[(output.index('Ping: ') + 6)..(output.index('ms')-2)]
download = output[(output.index('Download: ') + 10)..(output.index('Mbit')-2)]
upload = output[(output.index('Upload: ') + 8)..(output.length - 9)]
logger.debug('Download speed: ' + download + ' Mbit/s')

# OSX vs. Linux
logger.debug('Getting SSID')
begin
  ssid = %x[iwgetid -r].strip
rescue
  ssid = (`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`).strip
end
ssid = "en0" if ssid == ""
logger.debug(ssid)
logger.debug('Getting hostname')
hostname = Socket.gethostname
logger.debug(hostname)
logger.debug('Posting to API')
uri = URI('http://speedy-cnx.herokuapp.com/speedtests')

req = Net::HTTP::Post.new(uri)
req.set_form_data({ping: ping, upload: upload, download: download, ssid: ssid, hostname: hostname})

res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

case res
when Net::HTTPSuccess, Net::HTTPRedirection
  logger.debug('API Success')
else
  res.value
  logger.debug('API Fail')
end

logger.debug('Finished CRON')
