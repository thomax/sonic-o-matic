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
    method_option :twitter,
                  :type => :boolean,
                  :aliases => "-t",
                  :required => false,
                  :default => true,
                  :desc => "Don't start the Twitter listener, just play music in playlist."
    def start
      STDOUT.sync = true

      twitter_thread = Thread.new do
        listener = TwitterListener.new(options['playlist_file_name'], options['keyword'])
        listener.run
      end
      player = Player.new(options['playlist_file_name'], options['shuffle'])
      player.play
    end

  end
end
