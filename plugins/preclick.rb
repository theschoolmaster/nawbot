module Nawbot
  module Plugins
    class Preclick
      include Cinch::Plugin
      include HTTParty

      listen_to :channel

      def listen(m)
        URI.extract(m.message, ["https", "http"]) do |url|
          case url
            when /youtube\.com/
              resp = self.class.get(url)
              doc = Nokogiri::HTML(resp.body)
              title = doc.title.strip.gsub("\n      - YouTube",'')
              m.reply Cinch::Formatting.format(:blue, "Youtube: #{title}")
            when /imgur\.com/
              resp = self.class.get(url)
              doc = Nokogiri::HTML(resp.body)
              title = doc.title.strip.gsub(" - Imgur",'')
              m.reply Cinch::Formatting.format(:blue, "Imgur: #{title}")
            else
              resp = self.class.get(url)
              doc = Nokogiri::HTML(resp.body)
              title = doc.title.strip
              uri = URI.parse(url)
              m.reply Cinch::Formatting.format(:blue, "#{uri.host}: #{title}")
          end
        end

      end
    end
  end
end
