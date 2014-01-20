module Nawbot
  module Plugins

    class TextLogan
      include Cinch::Plugin

      match /text_logan|text logan/

      def initialize(*args)
        super
        @texts = ['Are you coming? My battery ubisnabkit to do above the tondo. And',
                'Fish',
                'Can your poco me up',
                'Alol-zgah hayha',
                'Umm. I might need a rode ho lpl',
                'Hi',
                'U Jane fps for toy',
                'Gosh',
                'My battery us dying']
      end

      def execute(m)
        m.reply(@texts.sample)
      end
    end

  end
end
