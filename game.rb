require_relative "./board.rb"
require_relative "./card.rb"

class Game
    def initialize(dimension1, dimension2)
        @board = Board.new(dimension1, dimension2)

        @prev_guessed_pos = nil
    end

    def get_input
        puts "Please enter the position of your guess (eg. 1,0):"
        input = gets.chomp.split(",")

        if input.any? {|ele| ele.to_i.to_s!= ele} || input.length != 2 
            raise "Your input format is invalid."
        end

        if input[0].to_i < 0 || input[0].to_i >= @board.grid.length || input[1].to_i < 0 || input[1].to_i >= @board.grid[0].length
            raise "Your input is out-of-bounds."
        end

        input.map(&:to_i)
    end

    def evaluate_helper(pos)
        if pos == @prev_guessed_pos
            puts "This is the same position, try again"
            @board[@prev_guessed_pos[0], @prev_guessed_pos[1]].hide
            sleep(1)
        elsif @board[pos[0], pos[1]] == @board[@prev_guessed_pos[0], @prev_guessed_pos[1]]
            puts "You found a match!\n"
            sleep(1)
        else
            sleep(1)
            @board[pos[0], pos[1]].hide
            @board[@prev_guessed_pos[0], @prev_guessed_pos[1]].hide
            puts "Try again\n"
            sleep(1)
        end

        @prev_guessed_pos = nil
    end

    def evaluate_guess(pos)
        # If user has already matched this position, no need to move forward
        if @board[pos[0], pos[1]].revealed == true
            puts "You already matched this position, try again"
            sleep(1)
        else
            @board[pos[0], pos[1]].reveal
            system "clear"
            @board.render

            if @prev_guessed_pos == nil
                @prev_guessed_pos = pos
            else
                evaluate_helper(pos)
            end
        end
    end

    def play
        @board.populate
        while !@board.won?
            system "clear"
            @board.render
            evaluate_guess(get_input)
        end
        puts "Congratulations, you won!"
    end
end

g = Game.new(2,4)
g.play