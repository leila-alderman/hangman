class Player
    attr_accessor :name

    def initialize(name)
        @name = name
    end
end

class Game
    def initialize
    end

    # Select a random word of 5 to 12 letters from the dictionary file.
    def get_word(dictionary)
        word = dictionary[rand(dictionary.length)]
        # Ensure that the word is between 5 and 12 letters long.
        if word.length.between?(5,12)
            return word.downcase.strip
        else
            get_word
        end
    end

    def show_board(game_status)
        puts "Incorrect guesses: "
        puts game_status[:incorrect_guesses].join(", ")
        puts "Word to guess:"
        puts game_status[:word].join(" ")
        puts "Answer:"
        puts game_status[:secret_word].join("")
    end

    def play
        status = start_game
        show_board(status)
        playing = true
        while playing == true
            status = round(status)
            playing = false if status == false
            show_board(status)
        end
    end

    def start_game
        dictionary = File.readlines("dictionary.txt")
        secret_word = get_word(dictionary).split("")
        word = secret_word.map { |x| x = "_" }
        game_status = {
            secret_word: secret_word,
            word: word,
            incorrect_guesses: []
        }
    end

    def round(game_status)
        puts "Guess a new letter! Otherwise, enter 1 to solve the puzzle or 0 to quit."
        guess = gets.chomp.downcase
        if guess == "0"
            return false
        elsif guess == "1"
            # Let the player guess the full answer.
        elsif guess.length > 1
            puts "Please enter only one letter at a time. Try again."
            round(game_status)
        else
            if game_status[:secret_word].include?(guess)
                game_status[:secret_word].each_with_index do |letter, i|
                    game_status[:word][i] = guess if game_status[:secret_word][i] == guess
                end
            else
                game_status[:incorrect_guesses] << guess
            end
        end
        game_status
    end

end

game = Game.new
game.play