#!/usr/bin/env ruby

# To run from command line:
# $ ruby exercise.rb n 
# where n is a perfect square
class PerfectSquareExercise

  Position = Struct.new(:column, :row) do
    def outside_of_root_bounds? bound
      column < 0 || row < 0 || column >= bound || row >= bound
    end
  end

  attr_accessor :n, :matrix_rows

  def initialize n
    @n = n.to_i
    raise ArgumentError, "Must provide a perfect square" unless n_is_perfect_square?
    @matrix_rows = Array.new(square_root){Array.new(square_root)}
    setup_matrix_rows
  end

  def print_matrix
    maximum_value_size = matrix_rows.flatten.max.to_s.length
    matrix_rows.each do |row|
      STDOUT.puts row.map{|val| val.to_s.ljust(maximum_value_size)}.join(' ')
    end
  end

  def setup_matrix_rows
    current_position = starting_position
    current_direction = starting_direction
    (1..n).reverse_each do |val|
      matrix_rows[current_position.column][current_position.row] = val
      next_position = next_position_for(current_position, current_direction)
      if next_position.outside_of_root_bounds?(square_root) || matrix_rows[next_position.column][next_position.row]
        current_direction = next_direction_for(current_direction)
        current_position = next_position_for(current_position, current_direction)
      else
        current_position = next_position
      end
    end
  end

  def next_position_for position, direction
    case direction
    when :right
      Position.new(position.column, position.row + 1)
    when :down
      Position.new(position.column + 1, position.row)
    when :left
      Position.new(position.column, position.row - 1)
    when :up
      Position.new(position.column - 1, position.row)
    end
  end

  def next_direction_for direction
    case direction
    when :right
      :down
    when :down
      :left
    when :left
      :up
    when :up
      :right
    end
  end

  # if n is even, it will be at top left
  # if n is odd, it will be in the bottom right
  def starting_position
    if n.even?
      Position.new(0,0)
    else
      Position.new(square_root - 1, square_root - 1)
    end
  end

  def starting_direction
    n.even? ? :right : :left
  end

  def square_root
    Math.sqrt(n)
  end

  def n_is_perfect_square?
    n > 0 && n == square_root.floor**2
  end
end

begin
  PerfectSquareExercise.new(ARGV[0]).print_matrix
rescue ArgumentError => e
  $stderr.puts "#{e}"
  exit(1)
end
