module Nawbot
  module Plugins
    class WuName
      include Cinch::Plugin
      include HTTParty

      match /^!wutang (.+)/, use_prefix: false

      def wu_name(string)
        url = "http://www.mess.be/inickgenwuname.php"
        response = HTTParty.post(  url, body: { realname: string, Submut: 'Enter the Wu-Tang' }   )
        the_worst_page_ever = Nokogiri::HTML(response.body)
        new_wu_name = the_worst_page_ever.search('font')[1].inner_text.gsub!(/\n/,'')
        "#{string}, from this day forward you will also be known as #{new_wu_name}"
      end

      def execute(m, string)
        m.reply wu_name(string)
      end

    end
  end
end
