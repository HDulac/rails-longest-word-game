require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U)

  def new
    # @letters = ('a'..'z').to_a.sample(10)
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  # def score
  #   @attempt = params[:attempt].split('')
  #   @letters = params[:letters].split('')
  #   @valid = if @attempt.all? { |letter| @letters.include?(letter) }
  #              "It's a great word"
  #            end
  # end
  def score
    @letters = params[:letters].split
    @word = (params[:word] || '').upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
