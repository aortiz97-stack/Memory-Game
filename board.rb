require_relative "./card.rb"
require "byebug"
class Board
    attr_reader :grid
    def initialize(dimension1, dimension2)
        if (dimension1 * dimension2 > 52) || (dimension1 * dimension2 % 2 != 0)
            raise "The grid dimensions are either too large or odd."
        end
        @grid = Array.new(dimension1) {Array.new(dimension2)}
    end

    def [](pos1, pos2)
        @grid[pos1][pos2]
    end

    def []=(pos1, pos2, value)
        @grid[pos1][pos2] = value
    end

    def get_letters_i(already_in)
        letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        random_letter_i = rand(0...26).to_i
        while already_in.include?(letters[random_letter_i])
            random_letter_i = rand(0...26).to_i
        end

        random_letter_i
    end

    def get_random_loc
        random_row = rand(0...@grid.length).to_i
        random_column = rand(0...@grid[0].length).to_i

        while self[random_row,random_column] != nil
            random_row = rand(0...@grid.length).to_i
            random_column = rand(0...@grid[0].length).to_i
        end

        [random_row, random_column]
    end

    def populate
        letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        already_in = []

        (0...@grid.length).each do |row_num|
            (0...@grid[0].length).each do |column_num|
                if self[row_num, column_num] == nil
                    random_letter_i = get_letters_i(already_in)
                    
                    self[row_num, column_num] = Card.new(letters[random_letter_i])
                    random_loc = get_random_loc
                    random_row, random_column = random_loc[0], random_loc[1]

                    self[random_row, random_column] = Card.new(letters[random_letter_i])
                    already_in << letters[random_letter_i]
                end
            end
        end

    end

    def render_first_line
        first_line = "_ "
        column_num = 0
        while column_num < @grid[0].length
            rest_of_line = column_num.to_s
            rest_of_line += " " if column_num != @grid[0].length-1
            first_line += rest_of_line
            column_num +=1
        end

       first_line += "\n"
    end

    def render
        puts render_first_line

        row_num = 0

        while row_num < @grid.length
            line = (row_num.to_s + " ")

            (0...@grid[row_num].length).each do |column_num|
                line += self[row_num, column_num].to_s
                line += " " if column_num != @grid[row_num].length-1
            end

            line += "\n"
            puts line

            row_num +=1
        end

    end

    def won?
        @grid.all? do |row|
            row.all? do |loc|
                return false if loc == nil
                loc.revealed == true
            end
        end
    end

    def reveal(pos)
        self[pos[0], pos[1]].reveal
    end
end

