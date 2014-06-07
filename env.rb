gems = [
  'cinch',
  'open-uri',
  'nokogiri',
  'cgi',
  'httparty',
  'google/api_client',
  'cinch/formatting',
  'cinch/plugins/last_seen',
  'cinch/plugins/downforeveryone',
  'cinch/plugins/urbandictionary',
  'cinch/plugins/reddit'
]

gems.each { |file| require file }

# include local plugins
Dir.glob(File.expand_path("./plugins/*.rb")).each do |file|
  require file
end
