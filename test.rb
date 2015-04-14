require_relative 'objects.rb'
require 'test/unit'
include Test::Unit::Assertions


def test_creature_creation
  (1..10).each do |i|
    creature = Creature.new(10, 10)
    assert(creature.get_x_location() < 10, "creature #{i} has incorrect x location")
    assert(creature.get_y_location() < 10, "creature #{i} has incorrect y location")
  end
  puts "creature creation passed"
end

test_creature_creation
