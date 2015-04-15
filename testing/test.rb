require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'
require_relative '../lib/world.rb'
require 'test/unit'
include Test::Unit::Assertions


def test_creature_creation
  puts "TESTS CREATURE CREATION"
  (1..10).each do |i|
    creature = Creature.new(9, 9)
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

def get_creature_test
  world = World.new(5, 5)
  world.add_creature_coordinate(3, 3)
  assert(world.get_creature(3, 3) != nil, "could not find creature")
  assert(world.get_creature(1, 1).nil?  , "should be nil")
end

def creature_movement_north
  puts 'NORTH'
  world = World.new(5, 5)
  world.display_world
  world.add_creature_coordinate(2, 0)
  world.display_world
  assert(world.get_creature(2, 0).can_move_north == false, "creature should not be able to move NORTH")
end

def creature_movement_west
  puts 'WEST'
  world = World.new(5, 5)
  world.display_world
  world.add_creature_coordinate(0, 2)
  world.display_world
  assert(world.get_creature(0, 2).can_move_west == false, "creature should not be able to move WEST")
end

def creature_movement_south
  puts 'SOUTH'
  world = World.new(5, 5)
  world.display_world
  world.add_creature_coordinate(2, 4)
  world.display_world
  assert(world.get_creature(2, 4).can_move_south == false, "creature should not be able to move SOUTH")
end

def creature_movement_east
  puts 'EAST'
  world = World.new(5, 5)
  world.display_world
  world.add_creature_coordinate(4, 2)
  world.display_world
  assert(world.get_creature(4, 2).can_move_east == false, "creature should not be able to move EAST")
end

def ok_creature_movement
  world = World.new(5, 5)
  world.add_creature_coordinate(2, 2)
  world.display_world
  assert(world.get_creature(2,2).can_move_north == true, "creature should be able to move NORTH")
  assert(world.get_creature(2,2).can_move_south == true, "creature should be able to move SOUTH")
  assert(world.get_creature(2,2).can_move_east == true, "creature should be able to move EAST")
  assert(world.get_creature(2,2).can_move_west == true, "creature should be able to move WEST")
end

def random_creature_movement
  world = World.new(5, 5)
  world.add_creature
  iterations = 10
  while iterations > 0
    world.display_world
    world.do_iteration
    iterations -= 1
  end
  world.display_world
end

def movement_tests
  creature_movement_north
  creature_movement_south
  creature_movement_west
  creature_movement_east
  ok_creature_movement
end


def run_tests
  # test_creature_creation
  # test_line
  # test_matrix
  # get_creature_test
  # movement_tests
  random_creature_movement
end

run_tests
