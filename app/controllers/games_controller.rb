require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @grid = []
    10.times{ @grid << alphabet[rand(0..25)] }
  end

  def score 
    attempt = params[:longest_word]
    grid = params[:grid].split("")
    start_time = params[:start_time]
    end_time = Time.now
    time = end_time.to_f - start_time.to_f

    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)

    letter_exists_array = []
    attempt_array = attempt.upcase.split("")
    grid_copy = grid.dup
    attempt_array.each do |letter|
      letter_exists_array << grid_copy.include?(letter)
      if grid_copy.include?(letter)
        index = grid_copy.index(letter)
        grid_copy.delete_at(index)
      end
    end
    word_not_in_grid = letter_exists_array.include?(false)
    @message = ""
    puts letter_exists_array
    puts word_not_in_grid
    if word_not_in_grid
      @score = 0
      @message = "Sorry but #{attempt} can't be built out of #{grid.join}"
    elsif word["found"]
      @score = word["length"].to_f / time
      @message = "Congratulations, #{attempt} is a valid English word!"
    else
      @score = 0
      @message = "Sorry but #{attempt} does not seem to be a valid English word..."
    end
  end
end

