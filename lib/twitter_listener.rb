require 'tweetstream'
require 'net/http'
require 'uri'

module SonicOMatic

  DIVISOR = ' [o=o] '

  class TwitterListener

    def self.run(file = nil)
      new(file).run
    end

    attr_reader :logfile
    def initialize(file)
      @logfile = file
      TweetStream.configure do |config|
        config.consumer_key       = 'oA1vxvJV2aJ8zipx6lw5A'
        config.consumer_secret    = 'x1goeXg9Kgz5svT4DXMMM6xnYXjqfHiACupBZaRe35M'
        config.oauth_token        = '1436071-NO6DOW44WzEjtPYwOUIVskkAZrR0c6nGlv7OxpzRsM'
        config.oauth_token_secret = 'PKfYlRDoFRB2kUISq3mFbaYJkPBzra4pYYYr2p38Ik'
        config.auth_method        = :oauth
      end
    end

    def run
      puts "Started!"
      TweetStream::Client.new.track('#spotify') do |status|
        track_codes_from_text(status.text).each do |track_code|
          track_info = "#{track_code}#{SonicOMatic::DIVISOR}#{status.text}"
          puts track_info
          append_to_log track_info
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
      if File.exists?(logfile)
        file = File.open(logfile, 'a')
      else
        file = File.new(logfile, 'w')
      end
      file.puts track_info
      file.close
    end

    def logfile
      @logfile ||= "playlist.txt"
    end

  end
end