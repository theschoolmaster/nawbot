module Nawbot
  module Plugins
    class UrbanDictionary
      include Cinch::Plugin
      include HTTParty

      match /!urban (.+)/, use_prefix: false

      def execute m, term
        m.reply search(term)
      end

      private
      def search(query)
        response = self.class.get 'http://urbandictionary.com/define.php/', query: { term: query }
        document = Nokogiri.HTML( response ).at_css('.meaning').text.strip.gsub(/\r/, ' ')
      end

    end
  end
end



