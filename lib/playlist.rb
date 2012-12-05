require 'hallon'

module SonicOMatic

  class Playlist

    attr_accessor :queue
    def initialize
      @queue = []
    end

    def add(track)
      queue << track
    end

    def remove(n = 0)
      queue.delete_at(n)
    end

    def empty
      queue.clear
    end

    def next(random = false)
      unless queue.empty?
        random ? queue.sample : queue[0]
      end
    end

    def print
      queue.each do |track_code|
        track = Hallon::Track.new(track_code)
        track.load
        artist = track.artist.load
        puts "#{artist.name} - #{track.name}"
      end
    end

  end


end
