require 'byebug'
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    if included?(@word, @letters)
      if english_word?(@word)
        score = compute_score(@word)
        @message = "Well done! Your score is #{score}"
      else
        @message = 'Not an English Word! Your score is 0'
      end
    else
      @message = 'Not in the grid! Your score is 0'
    end
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt)
    attempt.size * (10.0)
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
