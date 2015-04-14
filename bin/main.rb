require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'
require_relative '../lib/world.rb'


if ARGV.length != 2
  puts "ERROR: Need 2 inputs for x and y values of array"
  exit
else
  world = World.new(ARGV[0].to_i, ARGV[1].to_i)
end


# Ask questions about regeneration/number of monsters, strawberries and mushrooms
# Create $x_size by $y_size arrays for storage of different objects

# Create creatures. population could be done better
(0..2).each { world.add_creature }
# print world.get_coords_used
# puts ""

(0..2).each { world.add_monster }
# print world.get_coords_used
# puts ""

(0..1).each { world.add_strawberry }
# print world.get_coords_used
# puts ""

(0..1).each { world.add_mushroom }
# print "#{world.get_coords_used}\n"

world_array = world.get_world_array
# print world_array
world.display_world
# world.display_coordinates
