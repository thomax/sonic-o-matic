require 'hallon'

module SonicOMatic

  class Playlist

    attr_accessor :queue
    def initialize
      @queue = []
    end

    def next_random
      reload
      @queue.sample
    end

    def next(index = 0)
      reload
      @queue[index]
    end

    def reload
      playlist_file = File.open("playlist.txt", 'r')
      @queue = []
      playlist_file.each {|line| @queue << line }
      playlist_file.close
      puts "  ==== #{queue.count} tracks in playlist"
    end

  end


end
