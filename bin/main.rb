require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'
require_relative '../lib/world.rb'


if ARGV.length != 2
  puts "ERROR: Need 2 inputs for x and y values of array"
  exit
else
  world = World.new(ARGV[0].to_i, ARGV[1].to_i)
end

world.initialize_world

generations = 10

while generations > 0
  time_step = 10
  while time_step > 0
    world.iterate
    world.display_world
    time_step -=1
  end
  generations -=1
end
