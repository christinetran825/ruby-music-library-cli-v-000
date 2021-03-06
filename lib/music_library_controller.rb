require 'pry'

class MusicLibraryController

  attr_accessor :path

  def initialize(path = "./db/mp3s") #the 'path' argument defaults to './db/mp3s'
    MusicImporter.new(path).import #creates a new MusicImporter object, passing in the 'path' value, invokes the #import method on the created MusicImporter object
  end

  def call #loops and asks for user input until they type in exit, asks the user for input, welcomes the user
    input = ""
    until input == "exit"
      puts "Welcome to your music library!"
      puts "To list all of your songs, enter 'list songs'."
      puts "To list all of the artists in your library, enter 'list artists'."
      puts "To list all of the genres in your library, enter 'list genres'."
      puts "To list all of the songs by a particular artist, enter 'list artist'."
      puts "To list all of the songs of a particular genre, enter 'list genre'."
      puts "To play a song, enter 'play song'."
      puts "To quit, type 'exit'."
      puts "What would you like to do?"

      input = gets.strip

      case input
      when "list songs"
        list_songs
      when "list artists"
        list_artists
      when "list genres"
        list_genres
      when "list artist"
        list_songs_by_artist
      when "list genre"
        list_songs_by_genre
      when "play song"
        play_song
      end
    end
  end

#CLI Methods

  def list_songs
    #binding.pry
    Song.all.sort { |song_a, song_b| song_a.name <=> song_b.name }.each.with_index(1) do |song, index|
      puts "#{index}. #{song.artist.name} - #{song.name} - #{song.genre.name}"
    end
  end

  def list_artists
    Artist.all.sort {|artist_a, artist_b| artist_a.name <=> artist_b.name }.each.with_index(1) do |artist, index|
      puts "#{index}. #{artist.name}"
    end
  end

  def list_genres
    Genre.all.sort {|genre_a, genre_b| genre_a.name <=> genre_b.name }.each.with_index(1) do |genre, index|
      puts "#{index}. #{genre.name}"
    end
  end

  def list_songs_by_artist #prints all songs by a particular artist in a numbered list (alphabetized by song name)
    puts "Please enter the name of an artist:"
    input = gets.strip
    if artist = Artist.find_by_name(input)
      artist.songs.sort { |artist_a, artist_b| artist_a.name <=> artist_b.name }.each.with_index(1) do |song, index|
        puts "#{index}. #{song.name} - #{song.genre.name}"
      end
    end
  end

  def list_songs_by_genre #prints all songs by a particular genre in a numbered list (alphabetized by song name)
    puts "Please enter the name of a genre:"
    input = gets.strip
    if genre = Genre.find_by_name(input)
      genre.songs.sort { |genre_a, genre_b| genre_a.name <=> genre_b.name }.each.with_index(1) do |song, index|
        puts "#{index}. #{song.artist.name} - #{song.name}"
      end
    end
  end

  def play_song
    puts "Which song number would you like to play?"
    #binding.pry
    input = gets.strip.to_i
      if input.between?(1, Song.all.length)
        song = Song.all.sort{ |song_a, song_b| song_a.name <=> song_b.name }[input - 1]
      end
    puts "Playing #{song.name} by #{song.artist.name}" if song
  end

end
