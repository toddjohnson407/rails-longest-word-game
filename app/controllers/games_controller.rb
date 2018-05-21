require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    letter = ('a'..'z').to_a
    random_selection = []
    scanned = (0..(10- 1))
    scanned.each do |ind|
      random_selection[ind] = letter.sample(1)
    end
    @letters = random_selection.flatten!
  end

  def score
    @word = params[:word]
    @end_time = Time.now
    @score = ((@end_time.to_i - @start_time.to_i) / 1000000 * @word.length)
    @letters = params[:available_letters]
    @letters_a = @letters.chars
    @check = @word.chars
    @validate = true
    @rep = 0

    @check.each do |letter|
      if @check.count(letter) != @letters_a.count(letter)
        @validate = false
      end
    end

    if @word.count(@letters) < @word.length
      @valid = "not valid"
    elsif dictionary? && @validate
      @valid = "valid, your score is #{@score}"
    else
      @valid = "not valid"
    end
  end

  def dictionary?
    @word = params[:word]
    if JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@word}").read)["found"] == true
      @message = "#{@word} is a word, well done"
      # @score = (@word.length.to_f / (end_time - start_time)) * 10
      return true
    end
  end
end
