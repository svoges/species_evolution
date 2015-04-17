require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'
require_relative '../lib/world.rb'


if ARGV.length != 2
  puts "ERROR: Need 2 inputs for x and y values of array"
  exit
else
  world = World.new(ARGV[0].to_i, ARGV[1].to_i)
end

# Create creatures. population could be done better
world.initialize_world

iterations = 5
while iterations > 0
  world.do_iteration
  iterations -= 1
end
