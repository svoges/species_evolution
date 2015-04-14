require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'
require 'test/unit'
include Test::Unit::Assertions


def test_creature_creation
  puts "TESTS CREATURE CREATION"
  (1..10).each do |i|
    creature = Creature.new(10, 10)
    assert(creature.get_x_location() < 10, "creature #{i} has incorrect x location")
    assert(creature.get_y_location() < 10, "creature #{i} has incorrect y location")
  end
end

def test_sample_line
  puts "SAMPLE LINE"
  width = 5
  length = 8
  Matrix.draw_line(width)
end

def draw_sample_matrix
  puts "SAMPLE MATRIX"
  width = 5
  length = 8
  Matrix.draw_matrix(length, width)
end

def test_line
  puts "TEST LINE"
  array = [0, 0, 1, 0, 1, 1, 1]
  Matrix.draw_line(array)
end

def test_matrix
  puts "TEST MATRIX"
  array = [0, 0, 0, 1, 1, 1, 2, 2, 2]
  Matrix.draw_matrix(array, 3, 3)
end

def run_tests
  # test_creature_creation
  test_line
  test_matrix
end

run_tests
