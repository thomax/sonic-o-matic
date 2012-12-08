require 'hallon'

module SonicOMatic

  class Playlist

    attr_accessor :queue, :file_name
    def initialize(file_name)
      @file_name = file_name
      @queue = []
    end

    def next_random
      reload
      track_info = @queue.sample
      return nil unless track_info
      track_code, tweet, user = track_info.split(SonicOMatic::DIVISOR)
      print_fancy_track_summary(tweet, user)
      track_code
    end

    def next(index = 0)
      reload
      track_info = @queue.count > index ? @queue[index] : nil
      return nil unless track_info
      track_code, tweet, user = track_info.split(SonicOMatic::DIVISOR)
      print_fancy_track_summary(tweet, user)
      track_code
    end

    def reload
      @queue = []
      if File.exists?(@file_name)
        playlist_file = File.open(@file_name, 'r')
        playlist_file.each {|line| @queue << line }
        playlist_file.close
        puts "  #{SonicOMatic::DIVISOR} #{queue.count} tracks in #{@file_name}"
      end
    end

    def print_fancy_track_summary(tweet, user)
      puts ""
      puts "  #{SonicOMatic::DIVISOR}#{tweet}"
      puts "         @#{user}"
      puts ""
    end



  end


end
