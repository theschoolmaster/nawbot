#!/usr/local/rvm/rubies/ruby-1.9.2-p320/bin/ruby
# encoding: UTF-8

require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'
require 'httparty'
require 'google/api_client'
require 'cinch/plugins/last_seen'
require 'cinch/plugins/downforeveryone'
require 'cinch/plugins/urbandictionary'
require 'cinch/plugins/reddit'

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
    url = "http://www.xboxleaders.com/api/profile/#{URI.escape(gamertag.strip)}.json"
    resp = self.class.get(url)
    if resp.parsed_response['Stat'] == 'ok'
      status = resp.parsed_response['Data']['OnlineStatus'] rescue nil
      unless status.nil?
        "#{gamertag}: #{status}"
      else
        "#{gamertag}: No status found."
      end
    else
      "#{gamertag}: Probably jerking it..."
    end
  end

  def execute(m, gamertag)
    m.reply CGI.unescapeHTML xboxlive(gamertag).chars.select{|i| i.valid_encoding?}.join
  end
  
end

class WuName
  include Cinch::Plugin
  include HTTParty
  
  match /^!wutang (.+)/, use_prefix: false

  def wu_name(arg)
    url = "http://www.mess.be/inickgenwuname.php"
    resp = self.class.post(url,
            :body => {
              :realname => string,
              :Submit => 'Enter the Wu-Tang'
            }
    )
    the_worst_page_ever = Nokogiri::HTML(resp.body)
    
    "#{arg}: from this day forward you will also be known as #{new_wu_name}"
  end

  def execute(m, arg)
    m.reply CGI.unescapeHTML wu_name(arg)
  end
  
end

class FlipShit
  include Cinch::Plugin

  match /flip/, method: :flip
  match /^flips (.+)/, use_prefix: false

  def flip(m, arg)
    m.reply "(╯°□°）╯︵ ┻━┻"
  end

  def execute(m, arg)
    if 'nawbot' == arg
      m.reply "I AM THE ONE WHO FLIPS"
    else
      m.reply "(╯°□°）╯︵ #{flip_text(arg)}"
    end
  end

  def flip_text(string)
    table ={
      # Check if I can also implement: øØåÅŒ and other diacritic characters. 
      # Perhaps force unrecognised characters to their ascii equivalent with iconv?
      [0x0E6].pack('U') => [0x1D46].pack('U'), #æ
      [0x0C6].pack('U') => [0x1D02].pack('U'), #Æ
      [0x153].pack('U') => [0x1D14].pack('U'), #œ
      "a" => [0x250].pack('U'),
      "A" => [0x2200].pack('U'),
      "b" => "q",
      "B" => [0x2107].pack('U'), #Could use better replacement (0x3BE)
      "c" => [0x254].pack('U'),
      "C" => [0x2183].pack('U'),
      "d" => "p",
      "D" => [0x25C3].pack('U'), #Could use better replacement; this triangle seems to combine with next char..
      "e" => [0x1DD].pack('U'),
      "E" => [0x18E].pack('U'),
      "f" => [0x25F].pack('U'),
      "F" => [0x2132].pack('U'),
      "g" => [0x183].pack('U'),
      "G" => [0x2141].pack('U'),
      "h" => [0x265].pack('U'),
      'H' => 'H',
      "i" => [0x131].pack('U'),
      'I' => 'I',
      "j" => [0x27E].pack('U'),
      "J" => [0x017F].pack('U'),
      "k" => [0x29E].pack('U'),
      # "l" => [0x283].pack('U'),
      "L" => [0x2142].pack('U'),
      "m" => [0x26F].pack('U'),
      'M' => 'W',
      "n" => "u",
      "N" => [0x1D0E].pack('U'),
      "p" => 'd',
      'q' => 'b',
      "r" => [0x279].pack('U'),
      "R" => [0x1D1A].pack('U'),
      "t" => [0x287].pack('U'),
      "T" => [0x22A5].pack('U'),
      "v" => [0x28C].pack('U'),
      "V" => [0x245].pack('U'),
      'u' => 'n',
      'U' => [0x22C2].pack('U'),
      "w" => [0x28D].pack('U'),
      "y" => [0x28E].pack('U'),
      'Y' => [0x2144].pack('U'),
      "." => [0x2D9].pack('U'),
      "[" => "]",
      "(" => ")",
      "{" => "}",
      "?" => [0x0BF].pack('U'),
      "!" => [0x0A1].pack('U'),
      "'" => ",",
      '"' => [0x201E].pack('U'),
      "<" => ">",
      ">" => "<",
      "_" => [0x203E].pack('U'),
      '&' => [0x214B].pack('U'),
      [0x203F].pack('U') => [0x2040].pack('U'),
      [0x2045].pack('U') => [0x2046].pack('U'),
      [0x2234].pack('U') => [0x2235].pack('U'),
      "\r" => "\n",
    }
    revtext = []
    string.each_char do |char|
      if table.has_key?(char)
        revtext << table[char]
        next
      end
      if table.has_key?(char.downcase) #Fallback for lowercase characters.
        revtext << table[char.downcase]
        next
      end
      revtext << char
    end
    revtext.reverse.join('').gsub(")-;","(-;").gsub(")-:","(-:").gsub(");","(;").gsub(");","(;").gsub("(-:",")-:").gsub("(:","):").gsub("#{table["D"]}:","#{table["D"]}-:") #implement more common smiley correction
  end

end

class Google
  include Cinch::Plugin

  match /^!google (.+)/, use_prefix: false

  def search(query)
    url = "http://www.google.com/search?q=#{CGI.escape(query)}"
    res = Nokogiri::HTML(open(url)).at("h3.r")

    title = res.text
    link = res.at('a')[:href]
    desc = res.at("./following::div").children.first.text
    CGI.unescape_html "#{title} - #{desc} (#{link})"
  rescue
    "No results found"
  end

  def execute(m, query)
    m.reply(search(query))
  end
end

nawbot = Cinch::Bot.new do
  configure do |c|
    c.nick = "nawbot"
    c.password = "nawbotpass*123"
    c.server = "irc.freenode.org"
    c.channels = ["#reddit-naw","#nawbot-test"]
    #c.channels = ["#nawbot-test"]
    c.plugins.plugins = [Preclick, XboxLive, FlipShit, Google, Cinch::Plugins::Reddit, Cinch::Plugins::DownForEveryone, Cinch::Plugins::UrbanDictionary, Cinch::Plugins::LastSeen]
  end

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"
  end
  
  on :message, "hello nawbot" do |m|
    m.reply "Hello, #{m.user.nick}.  Very nice of you to think of me.  I was starting to feel neglected."
  end

  on :message, "lol" do |m|
    if 1 == rand(15)
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
