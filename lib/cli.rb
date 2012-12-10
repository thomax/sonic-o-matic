require_relative '../config/environment'
require 'thor'

module SonicOMatic

  class CLI < Thor

    desc "start", "Start the twitter listener and play songs as they come in."
    method_option :shuffle,
                  :type => :boolean,
                  :aliases => "-s",
                  :required => false,
                  :default => false,
                  :desc => "Play songs in random order."
    method_option :playlist_file_name,
                  :type => :string,
                  :aliases => "-p",
                  :required => false,
                  :default => "playlists/#{Date.today.to_s}.txt",
                  :desc => "Playlist file name."
    method_option :keyword,
                  :type => :string,
                  :aliases => "-k",
                  :required => false,
                  :default => nil,
                  :desc => "Additional twitter keyword, e.g. '@username' or '#jazz'."
    method_option :run_twitter_listener,
                  :type => :boolean,
                  :aliases => "-t",
                  :required => false,
                  :default => true,
                  :desc => "Start the Twitter listener, disable to just play music from playlist."
    def start
      STDOUT.sync = true
      run_twitter_listener if options['run_twitter_listener']
      run_player
    end

    private

    def run_twitter_listener
      twitter_thread = Thread.new do
        listener = TwitterListener.new(options['playlist_file_name'], options['keyword'])
        listener.run
      end
    end

    def run_player
      player = Player.new(options['playlist_file_name'], options['shuffle'])
      loop do
        player.play
        show_wait_cursor 5
      end
    end

    def show_wait_cursor(seconds, fps=10)
      chars = %w[| / - \\]
      delay = 1.0/fps
      (seconds*fps).round.times{ |i|
        print chars[i % chars.length]
        sleep delay
        print "\b"
      }
    end

  end
end
