require 'colorize'
require './cell'

class Board
  def initialize(width, height)
    @width, @height = width, height
    @grid = Array.new(height) { Array.new(width, 0) }
    Cell.setPadding(1)
  end

  def load_ships(ships)
    $ships = ships
    ships.each { |ship| place_ship ship }
  end

  def place_ship(ship)

    can_fit = false

    until can_fit

      horizontal = rand(2) == 1  

      # Limit search space
      if horizontal
        max_x = @width - ship.get_size
        max_y = @height - 1
      else
        max_x = @width - 1
        max_y = @height - ship.get_size
      end

      #try the coord
      x = rand (0..max_x)
      y = rand (0..max_y)

      can_fit = true

      if horizontal
        (0...ship.get_size).each do |index|
          if @grid[y][x+index] != 0 
            can_fit = false
            break
          end
        end
      else
        (0...ship.get_size).each do |index|
          if @grid[y+index][x] != 0 
            can_fit = false
            break
          end
        end
      end
    end

    if horizontal
      (0...ship.get_size).each { |index| @grid[y][x+index] = 1}
    else
      (0...ship.get_size).each { |index| @grid[y+index][x] = 1}
    end
  end

  def draw

    # Print x coords bar
    print Cell.new(" ").to_s
    (0...@grid.length).each { |x_coord| print Cell.new(x_coord).to_s }
    puts ""
  
    # Print cells
    @grid.each_with_index do |row, index|
      print Cell.new(index).to_s

      row.each do |cellData|
        cell = Cell.new cellData.to_s
        print cell.to_s.colorize(:background => :blue)
      end

      puts ""
    end

  end

end
