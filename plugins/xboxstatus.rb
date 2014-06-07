require "cinch/formatting"
require 'cgi'

class XboxStatus
  include HTTParty
  base_uri 'https://live.xbox.com/en-US/Profile'

  attr_accessor :status

  def initialize(gamertag)
    response = self.class.get '/', query: { gamertag: gamertag }
    @gamertag = gamertag
    @status = Nokogiri.parse(response).css('.presence').text
  end

  def presence
    if @status.nil?
      'Unknown Error'
    else
      CGI.unescapeHTML( @status )
    end
  end

  def pretty_status
    "#{@gamertag}: #{presence}"
  end

  def pretty_irc_status
    "%s: %s" % [Cinch::Formatting.format(:bold, @gamertag), Cinch::Formatting.format(:italic, presence)]
  end

end
