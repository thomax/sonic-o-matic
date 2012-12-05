require 'hallon'
require 'hallon-openal'

module SonicOMatic

  class Player

    attr_reader :shuffle
    def initialize(shuffle = false)
      session = Hallon::Session.initialize IO.read('config/spotify_appkey.key')
      user = SPOTIFY_CONFIG['development']['username']
      pass = SPOTIFY_CONFIG['development']['password']
      session.login!(user, pass)
      @suffle = shuffle
    end

    def queue(track_code = nil)
      track_code ||= 'spotify:track:1ZPsdTkzhDeHjA5c2Rnt2I'
      playlist.add track_code
      track_code = 'spotify:track:5IWmU2PNimgYuTLddU2DRo'
      playlist.add track_code
    end

    def show_playlist
      playlist.print
    end

    def play
      track = Hallon::Track.new playlist.next(shuffle)
      track.load
      artist = track.artist.load
      puts "playing\t #{artist.name} - #{track.name}"
      spotify_player.play! track
    end

    def spotify_player
      @spotify_player ||= Hallon::Player.new(Hallon::OpenAL)
    end

    def playlist
      @playlist ||= SonicOMatic::Playlist.new
    end

  end


end
