require 'xbox_leaders'
require "cinch/formatting"
require 'cgi'

class XboxStatus
  include HTTParty
  format :json
  base_uri 'https://www.xboxleaders.com/api/'

  attr_accessor :status

  def initialize(gamertag)
    response = self.class.get '/profile.json', query: { gamertag: gamertag }
    @gamertag = gamertag
    @status = response.parsed_response["data"]
  end

  def presence
    if @status['presence'].nil?
      'Unknown Error'
    else
      CGI.unescapeHTML( @status['presence'] )
    end
  end

  def pretty_status
    "#{@gamertag}: #{presence}"
  end

  def pretty_irc_status
    "%s: %s" % [Cinch::Formatting.format(:bold, @gamertag), Cinch::Formatting.format(:italic, presence)]
  end

end
