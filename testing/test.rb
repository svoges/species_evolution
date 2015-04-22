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
  world.display_world
  iterations = 10
  while iterations > 0
    world.do_iteration
    iterations -= 1
  end
end

def movement_tests
  person_movement_north
  person_movement_south
  person_movement_west
  person_movement_east
  ok_person_movement
end

def get_object
  world = World.new(5, 5)
  world.add_strawberry_coordinate(3, 3)
  assert(world.get_object_at_coord(3, 3).class == Strawberry, "objects indexed incorrectly")
  assert(world.get_object_at_coord(3, 4).nil? == true, "objects indexed incorrectly")
end

def eat_strawberry
  puts "======EAT STRAWBERRY TEST======="
  world = World.new(2, 1)
  world.add_person_coordinate(0, 0)
  world.add_strawberry_coordinate(1, 0)
  world.display_world
  strawb_number = world.get_objects_at_coord(1, 0)[0].get_amount
  puts strawb_number
  assert(world.get_objects_at_coord(0, 0)[0].class == Person, "objects indexed incorrectly")
  assert(world.get_objects_at_coord(1, 0)[0].class == Strawberry, "objects indexed incorrectly")
  world.do_iteration
  world.do_iteration
  assert(world.get_objects_at_coord(1, 0)[0].get_amount == strawb_number - 1, "Strawberry wasn't removed")
end

def eat_mushroom
  puts "======EAT MUSHROOM TEST======="
  world = World.new(2, 1)
  world.add_person_coordinate(0, 0)
  world.add_mushroom_coordinate(1, 0)
  world.display_world
  world.do_iteration
  world.do_iteration
  assert(world.get_persons.empty?, "Person didn't die from eating mushroom")
end

def touch_monster
  puts '=======TOUCH MONSTER TEST======'
  world = World.new(2, 1)
  world.add_person_coordinate(0, 0)
  world.add_monster_coordinate(1, 0)
  world.display_world
  world.do_iteration
  world.do_iteration
  assert(world.get_persons.empty?, 'Person didn\'t die from touching monster')
end

def test_world
  world = World.new(5, 5)
  world.initialize_world
end

def test_best_object
  world = World.new(1, 1)
  world.add_strawberry_coordinate(0, 0)
  world.add_person_coordinate(0, 0)
  world.display_world
end

def monster_movement
  world = World.new(5,5)
  world.add_monster
  (0..5).each do
    world.do_iteration
  end
end

def monster_strawb
  world = World.new(2, 1)
  world.add_monster
  world.add_strawberry
  world.do_iteration
  world.do_iteration
end

def full_movement_test
  world = World.new(4, 4)
  world.initialize_world
  (0..10).each do
    world.do_iteration
  end
end

def north_person
  world = World.new(1, 3)
  world.add_person_coordinate(0, 0)
  world.add_person_coordinate(0, 1)
  world.display_world
  world.get_objects_at_coord(0, 1)[0].move_random(world.get_world_array)
  world.display_world
end

def person_movement
  world = World.new(5, 5)
  (0..4).each do
    world.add_person
  end
  (0..5).each do
    world.do_iteration
  end
end

def no_movement
  world = World.new(2, 1)
  (0..1).each do
    world.add_person
  end
  (0..3).each do
    world.do_iteration
  end
end

def energy_drop
  world = World.new(2, 1, false, false)
  world.add_person
  (0..15).each do
    world.do_iteration
  end
  assert(world.get_persons.empty?, "person did not die")
end

def prune_array
  arr = Array.new
  arr.push(1, 2, 3)
  arr.push('four')
  arr.reject! { |elem| elem.class != 1.class }
  puts arr
end

def nearest_strawb
  world = World.new(5, 1, false, false)
  world.add_person_coordinate(1, 0)
  world.add_strawberry_coordinate(0, 0)
  world.add_strawberry_coordinate(4, 0)
  world.display_world
  world.do_iteration
  assert(world.get_objects_at_coord(0, 0)[1].class == Person, "Person moved in incorrect direction")
end

def euclidean_distance(obj1, obj2)
  Math.sqrt((obj1.get_x_location - obj2.get_x_location) ** 2 + (obj1.get_y_location - obj2.get_y_location) ** 2)
end

def nearest_strawberry(world_array)
  person = Person.new(1, 0, 5, 5)
  all_strawberries = world_array.reject { |elem| elem.class != Strawberry }
  min_distance = 1000 #Can never be larger than the size of the world
  nearest_strawberry = nil
  all_strawberries.each do |strawberry|
    distance = euclidean_distance(person, strawberry)
    puts distance
    if distance < min_distance
      nearest_strawberry = strawberry
      min_distance = distance
    end
  end
  [nearest_strawberry.get_x_location, nearest_strawberry.get_y_location]
end

def test_euclid
  strawb1 = Strawberry.new(0, 0)
  strawb2 = Strawberry.new(4, 0)
  arr = [strawb1, strawb2]
  nearest_strawberry(arr)
end

def find_creature
  world = World.new(10, 1, false, false)
  world.add_monster_coordinate(3, 0)
  world.add_person_coordinate(0, 0)
  world.add_person_coordinate(9, 0)
  world.display_world
  world.do_iteration
  assert(world.get_objects_at_coord(2, 0)[0].class == Monster, "monster moved in wrong direction")
end

def run_tests
  # test_world
  # test_best_object
  # test_person_creation
  # test_line
  # test_matrix
  # get_person_test
  # movement_tests
  # random_person_movement
  # get_object
  # eat_strawberry
  # eat_mushroom
  # touch_monster
  # monster_movement
  # full_movement_test
  # north_person
  # person_movement
  # no_movement
  # monster_strawb
  # energy_drop
  # prune_array
  # test_euclid
  # nearest_strawb
  find_creature
end

run_tests
