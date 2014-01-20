#!/usr/local/rvm/rubies/default/bin/ruby
# encoding: UTF-8

require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'
require 'httparty'
require 'xbox_leaders'
require 'google/api_client'
require "cinch/formatting"
require 'cinch/plugins/last_seen'
require 'cinch/plugins/downforeveryone'
require 'cinch/plugins/urbandictionary'
require 'cinch/plugins/reddit'

# include local plugins
Dir.glob(File.expand_path("./plugins/*.rb")).each do |file|
  require file
end


TEST = ARGV[0] == '--test'

nawbot = Cinch::Bot.new do
  configure do |c|
    if TEST
      c.nick = "nawbot-test"
      c.channels = ["#nawbot-test"]
    else
      c.nick = "nawbot"
      c.password = "nawbotpass*123"
      c.channels = ["#reddit-naw"]
    end

    c.server = "irc.freenode.org"
    c.plugins.plugins = [
                          Cinch::Plugins::Reddit,
                          Cinch::Plugins::DownForEveryone,
                          Cinch::Plugins::UrbanDictionary,
                          Cinch::Plugins::LastSeen,
                          Nawbot::Plugins::Preclick,
                          Nawbot::Plugins::XboxLive,
                          Nawbot::Plugins::XboxRally,
                          Nawbot::Plugins::FlipShit,
                          Nawbot::Plugins::TehGoog,
                          Nawbot::Plugins::Hitch,
                          Nawbot::Plugins::EightBall,
                          Nawbot::Plugins::TextLogan,
                          Nawbot::Plugins::WuName
                        ]
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
