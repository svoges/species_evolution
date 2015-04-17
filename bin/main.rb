require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'
require_relative '../lib/world.rb'


if ARGV.length < 2
  if ARGV.include?('-help')
    puts "Help information for Evolve a Species Project"
    puts "Usage: ruby [x_location] [y_location] [options]"
    puts "   -i      enable manual printing after each iteration"
    puts "   -m      enable manual printing after each movement"
    exit
  else
    puts "ERROR: Need 2 inputs for x and y values of array"
    exit
  end
elsif ARGV[0].to_i > 0 and ARGV[1].to_i > 0
  # if true, allows the user to step through each creature movement
  manual_movement = false
  # if true, allows the user to step through each world iteration
  manual_iteration = false
  if ARGV.include?('-i')
    manual_iteration = true
  end
  if ARGV.include?('-m')
    manual_movement = true
  end
  world = World.new(ARGV[0].to_i, ARGV[1].to_i, manual_movement, manual_iteration)
end

# Create creatures
world.initialize_world

iterations = 5
while iterations > 0
  world.do_iteration
  iterations -= 1
end
