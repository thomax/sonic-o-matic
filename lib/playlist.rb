require 'hallon'

module SonicOMatic

  class Playlist

    attr_accessor :queue
    def initialize
      @queue = []
    end

    def next_random
      reload
      track_info = @queue.sample
      track_code, tweet, user = track_info.split(SonicOMatic::DIVISOR)
      print_fancy_track_summary(tweet, user)
      track_code
    end

    def next(index = 0)
      reload
      track_info = @queue.count > index ? @queue[index] : nil
      track_code, tweet, user = track_info.split(SonicOMatic::DIVISOR)
      print_fancy_track_summary(tweet, user)
      track_code
    end

    def reload
      playlist_file = File.open("playlist.txt", 'r')
      @queue = []
      playlist_file.each {|line| @queue << line }
      playlist_file.close
      puts "  #{SonicOMatic::DIVISOR} #{queue.count} tracks in playlist"
    end

    def print_fancy_track_summary(tweet, user)
      puts ""
      puts "  #{SonicOMatic::DIVISOR}#{tweet}"
      puts "         @#{user}"
      puts ""
    end



  end


end
