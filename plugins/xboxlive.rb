module Nawbot
  module Plugins
    class XboxLive
      include Cinch::Plugin

      match /^!live (.+)/, use_prefix: false

      def execute(m, gamertag)
        xbs = XboxStatus.new(gamertag)
        m.reply xbs.pretty_irc_status
      end

    end
  end
end
