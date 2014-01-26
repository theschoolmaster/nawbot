module Nawbot
  module Plugins
    class XboxRally
      include Cinch::Plugin
      include HTTParty

      match /!rally/, use_prefix: false

      def execute(m)
        reply = ''
        gamertags = ["audibleblink", "theschoolmaster", "andrewigo", "oh hai loganz", "thingsomething", "mikesrt4"]
        gamertags.each do |gamertag|
          xbs = XboxStatus.new(gamertag)
          reply += xbs.pretty_irc_status
          reply += "\n"
        end
        m.reply reply
      end

    end

  end
end
