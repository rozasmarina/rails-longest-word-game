require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters =  10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    start_time = DateTime.parse(params[:time])
    end_time = Time.now
    total_time = end_time - start_time
    @word = params[:input]
    
    
    url= open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    obj = JSON.parse(url)
    
    if check_attempt(@word)
      if obj["found"]
        total_score = (@word.length * 100) - total_time
        @result = {message: "Well done!", time: total_time, score: total_score }
      else
        @result = {message: "#{@word} is not an english word", time: total_time, score: 0 }
      end
    else
      @result = {message: "#{@word} is not on the grid", time: total_time, score: 0 }
    end
    @result
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
