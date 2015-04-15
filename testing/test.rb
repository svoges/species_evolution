require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'
require_relative '../lib/world.rb'
require 'test/unit'
include Test::Unit::Assertions


def test_person_creation
  puts "TESTS PERSON CREATION"
  (1..10).each do |i|
    person = Person.new(9, 9)
    assert(person.get_x_location() < 10, "person #{i} has incorrect x location")
    assert(person.get_y_location() < 10, "person #{i} has incorrect y location")
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

def get_person_test
  world = World.new(5, 5)
  world.add_person_coordinate(3, 3)
  assert(world.get_person(3, 3) != nil, "could not find person")
  assert(world.get_person(1, 1).nil?  , "should be nil")
end

def person_movement_north
  puts 'NORTH'
  world = World.new(5, 5)
  world.display_world
  world.add_person_coordinate(2, 0)
  world.display_world
  assert(world.get_person(2, 0).can_move_north == false, "person should not be able to move NORTH")
end

def person_movement_west
  puts 'WEST'
  world = World.new(5, 5)
  world.display_world
  world.add_person_coordinate(0, 2)
  world.display_world
  assert(world.get_person(0, 2).can_move_west == false, "person should not be able to move WEST")
end

def person_movement_south
  puts 'SOUTH'
  world = World.new(5, 5)
  world.display_world
  world.add_person_coordinate(2, 4)
  world.display_world
  assert(world.get_person(2, 4).can_move_south == false, "person should not be able to move SOUTH")
end

def person_movement_east
  puts 'EAST'
  world = World.new(5, 5)
  world.display_world
  world.add_person_coordinate(4, 2)
  world.display_world
  assert(world.get_person(4, 2).can_move_east == false, "person should not be able to move EAST")
end

def ok_person_movement
  world = World.new(5, 5)
  world.add_person_coordinate(2, 2)
  world.display_world
  assert(world.get_person(2,2).can_move_north == true, "person should be able to move NORTH")
  assert(world.get_person(2,2).can_move_south == true, "person should be able to move SOUTH")
  assert(world.get_person(2,2).can_move_east == true, "person should be able to move EAST")
  assert(world.get_person(2,2).can_move_west == true, "person should be able to move WEST")
end

def random_person_movement
  world = World.new(5, 5)
  world.add_person
  iterations = 10
  while iterations > 0
    world.display_world
    world.do_iteration
    iterations -= 1
  end
  world.display_world
end

def movement_tests
  person_movement_north
  person_movement_south
  person_movement_west
  person_movement_east
  ok_person_movement
end


def run_tests
  # test_person_creation
  # test_line
  # test_matrix
  # get_person_test
  # movement_tests
  random_person_movement
end

run_tests
