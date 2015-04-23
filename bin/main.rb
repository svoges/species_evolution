require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'
require_relative '../lib/world.rb'
# require 'shoes'


if ARGV.length < 2
  if ARGV.include?('-help')
    puts "Help information for Evolve a Species Project"
    puts "Usage: ruby [x_location] [y_location] [options]"
    puts "   -i      enable manual printing after each iteration, 'exit' or 'quit' to abort"
    puts "   -m      enable manual printing after each movement, 'exit' or 'quit' to abort"
    puts "   -v      enable graphical mode"
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
  if ARGV.include?('-v')
    Shoes.app do
      flow do
        button 'push me'
      end
    end
  end
  world = World.new(ARGV[0].to_i, ARGV[1].to_i, manual_movement, manual_iteration)
end
world = World.new(ARGV[0].to_i, ARGV[1].to_i, manual_movement, manual_iteration)

# Create creatures
world.initialize_world

while !world.get_persons.empty?
  world.do_iteration
end
