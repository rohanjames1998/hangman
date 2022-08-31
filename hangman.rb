require 'pry-byebug'
require 'json'

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
      puts "\n"
      guess = gets.chomp.downcase
      if guess == 'save'
        return guess
      end
      # If player guess is not a single character alphabet we keep displaying error message.
      unless guess.size == 1 && guess.match(/[a-z]/i)
        puts "Please limit your guess to one character.",
             "And only English alphabets are allowed."
        next
      end
      return guess
    end
  end

  def check_player_guess(guess, incorrect_guesses, correct_guesses, word_arr)
    if guess == 'save'
      save_game(incorrect_guesses, correct_guesses, word_arr)
    elsif word_arr.include?(guess)
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

  def display_incorrect_guesses(incorrect_guesses)
    # Making incorrect_guesses elements presentable for displaying by adding space and commas between them
    display_str = "\nIncorrect guesses: "
    incorrect_guesses.each do |chr|
      display_str += chr.upcase
      display_str += ", "
    end
    puts display_str
  end

  def add_empty_dashes(correct_guesses, word_arr)
    # Filling correct_guesses Array with empty dashes equal to number of characters in the word array
    word_arr.each do |chr|
      correct_guesses << '_ '
    end
  end

  def display_correct_guesses(correct_guesses)
    display_str = "\n"
    # Making correct_guesses elements presentable for displaying by adding space between them
    correct_guesses.each do |chr|
      display_str += chr
      display_str += ' '
    end
    puts display_str
  end

  def display_hangman(number_of_incorrect_guesses)
    case
    when number_of_incorrect_guesses == 1
      puts "


  |_______
  |      |
  |
  |
  |
  |
  |

"
    when number_of_incorrect_guesses == 2
      puts "


  |_______
  |      |
  |      O
  |
  |
  |
  |

"
    when number_of_incorrect_guesses == 3
      puts "


  |_______
  |      |
  |      O
  |      |
  |      |
  |
  |

"
    when number_of_incorrect_guesses == 4
      puts "


  |_______
  |      |
  |      O
  |     /|
  |      |
  |
  |

"
    when number_of_incorrect_guesses == 5
      puts "


  |_______
  |      |
  |      O
  |     /|\\
  |      |
  |
  |

"
    when number_of_incorrect_guesses == 6
      puts "


  |_______
  |      |
  |      O
  |     /|\\
  |      |
  |     /
  |

"
    when number_of_incorrect_guesses == 7
      puts "


  |_______
  |      |
  |      O
  |     /|\\
  |      |
  |     / \\
  |

"
    end
  end

def end_game?(number_of_incorrect_guesses, correct_guesses, word_arr)
  if number_of_incorrect_guesses == 7
    puts "\nThe word was #{word_arr.join('')}"
    return true
  elsif correct_guesses == word_arr
    puts "\nCongratulations, you have successfully saved the man from dying!"
    return true
  end
end

def convert_to_json(incorrect_guesses, correct_guesses, word_arr)
  hash = {
    'incorrect_guesses' => incorrect_guesses,
    'correct_guesses' => correct_guesses,
    'word_arr' => word_arr,
  }.to_json
end


def save_game(incorrect_guesses, correct_guesses, word_arr)
  loop do
  print "\n Enter the name of your save file:"
  file_name = gets.chomp.downcase
  file_name += '.json'
  save_file = File.join('./saved_games', file_name)
  if File.exists?(save_file)
    puts "A save file with that name already exists.",
         "Please rename your save file"
         next
  else
    File.open(save_file, 'w') do |f|
      f.write(convert_to_json(incorrect_guesses, correct_guesses, word_arr))
    end
    puts "\nYour game has been successfully saved"
    break
  end
end
end

def get_file_name
  # This function checks if the file exists and returns the file if it does
  loop do
    player_input = gets.chomp.downcase + '.json'
    file_name_with_path = File.join('./saved_games', player_input)
    if File.exist?(file_name_with_path)
      return file_name_with_path
    else
      puts "Please choose a valid save file name"
      next
    end
  end
end

#This function returns a hash with previously saved values for instance variables
def load_saved_hash
  # This logic shows saved files
  path = "./saved_games"
  puts "\nPlease choose a save file:"
  Dir.each_child(path) do |f|
    saved_file_name = f.split(".")[0] #Showing file names without extension
    puts saved_file_name
  end
# Making sure the file name exists
  selected_file = File.read(get_file_name)
  saved_hash =  JSON.parse(selected_file)
  return saved_hash
end

def get_retry_choice
  loop do
  choice = gets.chomp.downcase
  if choice == 'y' || choice == 'n'
    return choice
  else
    print "Please enter 'y' if you want to play again, Or 'n' if you don't want to play again:"
  end

end
end

end

#--------------------------------#
# CLASSES
#--------------------------------#
class Game
  include GameFunctions

  def initialize
    @incorrect_guesses = []
    @correct_guesses = []
    @word_arr = []

    loop do
      puts "Do you want to play a new game?[New]",
      "Or load a saved game?[Load]:"
      choice = gets.chomp.downcase.strip
      if choice == "load"
        saved_hash = load_saved_hash
        @incorrect_guesses = saved_hash['incorrect_guesses']
        @correct_guesses = saved_hash['correct_guesses']
        @word_arr = saved_hash['word_arr']
        break
      elsif choice == "new"
        @word = get_secret_word
        @word_arr = word.split('')
    add_empty_dashes(correct_guesses, word_arr)
    break
         else
          puts "Please choose a valid option.",
               "Type 'new' for new game and 'load' to load a saved game."
               next
         end
        end
  end

  def round
    loop do
      number_of_incorrect_guesses = incorrect_guesses.size
      display_incorrect_guesses(incorrect_guesses)
      display_hangman(number_of_incorrect_guesses)
      display_correct_guesses(correct_guesses)
      break if end_game?(number_of_incorrect_guesses, correct_guesses, word_arr)
      guess = get_player_guess
      check_player_guess(guess, incorrect_guesses, correct_guesses, word_arr)
    end
  end

  private

  attr_reader :word

  attr_accessor :correct_guesses, :incorrect_guesses, :word_arr

end

#--------------------------------#
# GAME
#--------------------------------#
include GameFunctions

loop do
puts 'Hello and welcome to hangman!',
     'Try to guess the word in order to save the man from dying.',
     'After 7 wrong guesses the man will be hanged.'
'Good Luck!!'
game = Game.new
game.round

print "Wanna play another game? [Y/N]:"
choice = get_retry_choice
break if choice == 'n'
end



