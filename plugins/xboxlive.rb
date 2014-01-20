module Nawbot
  module Plugins
    class XboxLive
      include Cinch::Plugin
      include HTTParty

      match /^!live (.+)/, use_prefix: false

      def xboxlive(gamertag)
        api = XboxLeaders::Api.new

        begin

          resp = api.fetch_profile("#{URI.escape(gamertag.strip)}")
          is_online = resp["online"]
          is_online ? "#{gamertag}: #{resp["presence"]}" : "#{gamertag} offline: #{resp["presence"]}"

        rescue
          "#{gamertag}: Probably jerking it..."
        end

      end

      def execute(m, gamertag)
        m.reply CGI.unescapeHTML xboxlive(gamertag).chars.select{|i| i.valid_encoding?}.join
      end

    end
  end
end
