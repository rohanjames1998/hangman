require 'pry-byebug'

#--------------------------------#
# MODULES
#--------------------------------#
module GameFunctions

  def get_secret_word
    loop do
      rng = rand(9800)
      # Using strip to remove extra space if any
      word = File.open('google-10000-english-no-swears.txt').readlines[rng].strip
      if word.length.between?(5, 12)
        return word
      else
        next
      end
    end
  end

  def get_player_guess
    # If player guess is not a single character alphabet we keep displaying error message.
    loop do
    guess = gets.chomp.downcase
      unless guess.size == 1 && guess.match(/[a-z]/i)
        puts "Please limit your guess to one character.",
              "And only English alphabets are allowed."
              next
      end
    return guess
  end
end

def check_player_guess(guess, incorrect_guesses, correct_guesses, word_arr)
  if word_arr.include?(guess)
    word_arr.each_with_index do |letter, index|
      if letter == guess
        correct_guesses[index] = letter
      end
    end
    # This check is not make sure that incorrect guesses don't get put twice into the array
  elsif !incorrect_guesses.include?(guess)
    incorrect_guesses << guess
  end
end

end

#--------------------------------#
# CLASSES
#--------------------------------#
class Game

include GameFunctions


def initialize
  @word = get_secret_word
end

def round
incorrect_guesses = []
correct_guesses = {}
number_of_incorrect_guesses = incorrect_guesses.size
word_arr = word.split('')

loop do
  # display_hangman(number_of_incorrect_guesses)
  # display_incorrect_guesses(incorrect_guesses)
  # display_correct_guesses(correct_guesses)
  guess = get_player_guess
  check_player_guess(guess, incorrect_guesses, correct_guesses, word_arr)
  p incorrect_guesses
  p correct_guesses
  p word_arr
end
end

private

  attr_reader :word


end

#--------------------------------#
# GAME
#--------------------------------#
game = Game.new
puts 'Hello and welcome to hangman!',
      'Try to guess the word in order to save the man from dying.',
      'After 8 wrong guesses the man will be hanged.'
      'Good Luck!!'
      game.round
