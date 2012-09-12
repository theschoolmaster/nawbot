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
    URI.extract(m.message, "http") do |url|
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

class XboxLive
  include Cinch::Plugin
  include HTTParty
  
  match /^!live (.+)/, use_prefix: false

  def xboxlive(gamertag)
    url = "http://www.xboxleaders.com/api/profile/#{URI.escape(gamertag)}.json"
    resp = self.class.get(url)
    if resp.parsed_response['Stat'] == 'ok'
      status = resp.parsed_response['Data']['OnlineStatus'] rescue nil
      unless status.nil?
        "#{gamertag}: #{status}"
      end
    else
      "#{gamertag} status: Probably jerking it..."
    end
  end

  def execute(m, gamertag)
    m.reply CGI.unescapeHTML xboxlive(gamertag)
  end
  
end

nawbot = Cinch::Bot.new do
  configure do |c|
    c.nick = "nawbot"
    c.password = "nawbotpass*123"
    c.server = "irc.freenode.org"
    c.channels = ["#reddit-naw","#nawbot-test"]
    #c.channels = ["#nawbot-test"]
    c.plugins.plugins = [Preclick, XboxLive]
  end

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"
  end
  
  on :message, "hello nawbot" do |m|
    m.reply "Hello, #{m.user.nick}.  Very nice of you to think of me.  I was starting to feel neglected."
  end

  on :message, "lol" do |m|
    if 1 == rand(5)
      m.reply "lol indeed, #{m.user.nick}"
    end
  end

  on :message, "LOL" do |m|
    if 1 == rand(53)
      m.reply "L 0 freaking L"
    end
  end
end

nawbot.start
