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

(0..2).each { world.add_monster }

(0..1).each { world.add_strawberry }

(0..1).each { world.add_mushroom }

world_array = world.get_world_array
world.display_world
