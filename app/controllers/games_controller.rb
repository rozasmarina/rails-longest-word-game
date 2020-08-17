require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters =  10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:input]

    url= open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    obj = JSON.parse(url)
    
    if check_attempt(@word)
      if obj["found"]
        @message = "Well done!"
      else
        @message = "#{@word} is not an english word"
      end
    else
      @message = "#{@word} is not on the grid"
    end
  end

  def check_attempt (word)
    letters = params[:letters].split(" ")

    word.upcase.chars.each do |letter|
      if letters.include?letter
        i = letters.index(letter)
        letters.delete_at(i)
      else
        return false
      end
    end
    true
  end
end
