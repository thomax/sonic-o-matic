require 'tweetstream'
require 'net/http'
require 'uri'

module SonicOMatic

  DIVISOR = ' [o=o] '

  class TwitterListener

    attr_reader :logfile, :keyword
    def initialize(logfile, keyword = nil)
      @logfile = logfile
      @keyword = keyword
      configure_tweetstream
    end

    def run
      message = "Listening for 'spotify'"
      message << " and \'#{@keyword}\'" if @keyword
      message << " on Twitter"
      message << "\nLogging to #{@logfile}"
      puts message

      TweetStream::Client.new.track('spotify') do |status|
        if @keyword.nil? || status.text.downcase.include?(@keyword.downcase)
          track_codes_from_text(status.text).each do |track_code|
            track_info = "#{track_code}#{SonicOMatic::DIVISOR}#{status.text}#{SonicOMatic::DIVISOR}#{status.user.screen_name}"
            puts track_info
            append_to_log track_info
          end
        end
      end
    end

    def track_codes_from_text(text)
      track_codes = []
      urls = text.scan(/http:\/\/t.co\/[a-zA-Z\d]+/)
      urls.each do |url|
        url = Net::HTTP.get_response(URI.parse(url))['location'] # follow a redirect
        if url =~ /^http:\/\/spoti.fi\/[a-zA-Z\d]+/
          url = Net::HTTP.get_response(URI.parse(url))['location'] # follow another redirect
        end
        track_codes << url.split('track/')[1]
      end
      track_codes.compact
    end

    def append_to_log(track_info)
      if File.exists?(@logfile)
        file = File.open(@logfile, 'a')
      else
        file = File.new(@logfile, 'w')
      end
      file.puts track_info
      file.close
    end

    def configure_tweetstream
      TweetStream.configure do |config|
        config.consumer_key       = CONFIG['twitter']['consumer_key']
        config.consumer_secret    = CONFIG['twitter']['consumer_secret']
        config.oauth_token        = CONFIG['twitter']['oauth_token']
        config.oauth_token_secret = CONFIG['twitter']['oauth_token_secret']
        config.auth_method        = CONFIG['twitter']['auth_method']
      end
    end

  end
end