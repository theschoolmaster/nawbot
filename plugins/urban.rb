module Nawbot
  module Plugins
    class UrbanDictionary
      include Cinch::Plugin
      include HTTParty
      format :json
      base_uri "http://api.urbandictionary.com/"
      match /!urban (.+)/, use_prefix: false

      def execute m, term
        m.reply search(term)
      end

      private
      def search(query)
        response = self.class.get '/v0/define', query: { term: query }
        response['list'][0]['definition'].gsub(/\r\n/, ' ')
      end

    end
  end
end

