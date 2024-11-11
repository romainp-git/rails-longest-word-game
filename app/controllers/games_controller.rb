require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { [*"A".."Z"].sample }
    session[:letters] = @letters
  end

  def score
    @letters = session[:letters]
    @score = session[:score] || 0
    @result = run_game(params[:word])
  end

  def run_game(attempt)
    @message = "Not in the grid"
    if check_grid(attempt)
      if english(attempt)
        @score += attempt.size
        session[:score] = @score
        @message = "<strong>Congratulations!</strong> #{attempt.upcase} is a valid English word!"
      else
        @message = "Not an english word"
      end
    end
  end

  def check_grid(attempt)
    attempt.upcase.chars.tally.all? do |key, value|
      @letters.tally[key] && value <= @letters.tally[key]
    end
  end

  def english(attempt)
    url = "https://dictionary.lewagon.com/"
    word_serialized = URI.parse(url + attempt).read
    word = JSON.parse(word_serialized)
    return word["found"]
  end
end
