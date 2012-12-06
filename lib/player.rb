require 'hallon'
require 'hallon-openal'

# TODO:
# cli
# name the playlist in player.rb/playlist.rb
# some tests
# player.next/previous

module SonicOMatic

  class Player

    attr_accessor :shuffle, :playlist_position
    def initialize(shuffle = false)
      session = Hallon::Session.initialize IO.read('config/spotify_appkey.key')
      user = SPOTIFY_CONFIG['development']['username']
      pass = SPOTIFY_CONFIG['development']['password']
      session.login!(user, pass)
      @suffle = shuffle
      @playlist_position = 0
    end

    def next_track
      if @shuffle
        track_code = playlist.next_random
      else
        track_code = playlist.next @playlist_position
        @playlist_position += 1
      end
      return nil unless track_code
      "spotify:track:#{track_code}"
    end

    def play
      while track_pointer = next_track
        begin
          track = Hallon::Track.new track_pointer
        rescue ArgumentError
          puts "  #{SonicOMatic::DIVISOR} BOOM! Invalid track #{track_pointer}"
          next
        end
        begin
          track.load
          spotify_player.play! track
        rescue Hallon::Error
          puts "  #{SonicOMatic::DIVISOR} BOOM! Could not play #{track_pointer}"
        end
      end
    end

    def spotify_player
      @spotify_player ||= Hallon::Player.new(Hallon::OpenAL)
    end

    def playlist
      @playlist ||= SonicOMatic::Playlist.new
    end

  end


end
