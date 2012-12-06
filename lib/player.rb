require 'hallon'
require 'hallon-openal'

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
        track_info = playlist.next_random
      else
        @playlist_position += 1
        track_info = playlist.next @playlist_position
      end
      track_code = track_info.split(SonicOMatic::DIVISOR).first
      track = Hallon::Track.new "spotify:track:#{track_code}"
      track.load
      artist = track.artist.load
      puts "playing\t #{artist.name} - #{track.name}"
      puts ""
      puts "    " + track_info
      puts ""
      track
    end

    def play
      spotify_player.play! next_track
    end

    def spotify_player
      @spotify_player ||= Hallon::Player.new(Hallon::OpenAL)
    end

    def playlist
      @playlist ||= SonicOMatic::Playlist.new
    end

  end


end
