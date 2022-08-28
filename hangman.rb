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
    loop do
    guess = gets.chomp
    if guess.size != 1
      puts "Please keep your guess down to one character"
      next
    elsif !guess.match(/[a-z]/i)
      puts "Only English alphabetic characters are allowed"
      next
    end
    break
  end
gets.downcase
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
number_of_incorrect_guesses = 0

loop do
  # display_hangman(number_of_incorrect_guesses)
  # display_incorrect_guesses(incorrect_guesses)
  # display_correct_guesses(correct_gusses)
  guess = get_player_guess

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
