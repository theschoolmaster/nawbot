module Nawbot
  module Plugins
    class XboxRally
      include Cinch::Plugin
      include HTTParty

      match /!rally/, use_prefix: false

      def rally(name)
        api = XboxLeaders::Api.new
        begin
          resp = api.fetch_profile("#{URI.unescape(name.strip)}")
          is_online = resp["online"]
          is_online ? "#{name}: #{resp["presence"]}" : "#{name} is offline: #{resp["presence"]}"
        rescue
          "#{name}: Probably jerking it..."
        end
      end

      def execute(m)
        names = ["audibleblink", "theschoolmaster", "bftp", "oh hai loganz", "thingsomething", "mikesrt4"]
        names.each { |gt| m.reply rally(gt) }
      end

    end

  end
end
