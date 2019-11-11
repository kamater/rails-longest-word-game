require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    15.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    letters = params[:letters].chars
    @attempt = params[:wordTyped]
    error = ''
    @scoring = 0
    @win = ''

    array_of_letter = @attempt.upcase.chars

    # on verifie que le mot tapé est dans la grid
    if @attempt.size <= letters.length
      array_of_letter.each do |letter|
        if letters.index(letter).nil?
          @scoring = 0
          error = 'Your word does not match with the grid'
        else
          letter_index = letters.index(letter)
          # on supprime la lettre a cet index
          letters.delete_at(letter_index)
        end
      end
    end

    # puis on verifie si le mot est bien un mot anglais
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    user_attempt = open(url).read
    valid = JSON.parse(user_attempt)['found']

    if valid == true
      @scoring = @attempt.length * 10
    else
      @scoring = 0
    end

    # on definit la valeur de @win pour la view.
    if error != ''
      @win = 'griderror'
    elsif @scoring.positive?
      @win = 'win'
    else
      @win = 'englisherror'
    end
  end
end
