require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'
require 'httparty'

class Preclick
  include Cinch::Plugin
  include HTTParty
  
  listen_to :channel  

  def listen(m)
    URI.extract(m.message) do |url|
      case url
        when /youtube\.com/
          resp = self.class.get(url) 
          doc = Nokogiri::HTML(resp.body)
          title = doc.title.strip.gsub("\n      - YouTube",'')
          m.reply "Youtube: #{title}"
        when /imgur\.com/
          resp = self.class.get(url) 
          doc = Nokogiri::HTML(resp.body)
          title = doc.title.strip.gsub(" - Imgur",'')
          m.reply "Imgur: #{title}"
        else
          resp = self.class.get(url) 
          doc = Nokogiri::HTML(resp.body)
          title = doc.title.strip
          uri = URI.parse(url)
          m.reply "#{uri.host}: #{title}"
      end
    end
     
  end
end

nawbot = Cinch::Bot.new do
  configure do |c|
    c.nick = "nawbot"
    c.server = "irc.freenode.org"
    c.channels = ["#reddit-naw","#nawbot-test"]
    #c.channels = ["#nawbot-test"]
    c.plugins.plugins = [Preclick]
  end

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"
  end
  
end

nawbot.start
