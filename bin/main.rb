require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'
require_relative '../lib/world.rb'

if ARGV.length < 2
  if ARGV.include?('-help')
    puts "Help information for Evolve a Species Project"
    puts "Usage: ruby [x_location] [y_location] [options]"
    puts "   -t      enables teacher mode, where I give the presentation"
    puts "   -v      enable more detailed printing"
    puts "   -i      enable manual printing after each iteration, 'exit' or 'quit' to abort"
    puts "   -m      enable manual printing after each movement, 'exit' or 'quit' to abort"
    puts "   -g      enable generations mode"
    exit
  else
    puts "ERROR: Need 2 inputs for x and y values of array"
    exit
  end
elsif ARGV[0].to_i > 0 and ARGV[1].to_i > 0
  # if true, allows more detailed printing for creature movement
  printing = false
  # if true, allows the user to step through each creature movement
  manual_movement = false
  # if true, allows the user to step through each world iteration
  manual_iteration = false
  # if true, enables generational mode in which evolution will occur
  teacher_mode = false
  generations = false
  if ARGV.include?('-v')
    printing = true
  end
  if ARGV.include?('-t')
    teacher_mode = true
  end
  if ARGV.include?('-i')
    manual_iteration = true
  end
  if ARGV.include?('-m')
    manual_movement = true
  end
  if ARGV.include?('-g')
    puts "Enter for new generation, or exit to quit"
    generations = true
  end
  world = World.new(ARGV[0].to_i, ARGV[1].to_i, printing, manual_movement, manual_iteration)
end
world = World.new(ARGV[0].to_i, ARGV[1].to_i, printing, manual_movement, manual_iteration)

if teacher_mode
  # do presentation
  puts "Initial population behavior"
  initial_world = World.new(ARGV[0].to_i, ARGV[1].to_i, true, manual_movement, false)
  initial_world.populate
  input = ""
  while input != "quit" and input != "exit"
    initial_world.do_iteration
    puts "Press enter to continue"
    STDOUT.flush
    input = STDIN.gets.chomp
  end
end

if generations
  File.truncate('output/average.txt', 0)
  File.truncate('output/best.txt', 0)
  File.truncate('output/survivors.txt', 0)
  STDOUT.flush
  while world.get_generation < 200
    world.create_generation
    puts "======================#{world.get_generation}============================"
    world.populate
    iterations = 25
    while iterations > 0
      world.do_iteration
      iterations -= 1
    end
    world.generate_output
  end
  world.group_fitness
else
  # Create creatures
  world.populate
  while !world.get_persons.empty?
    world.do_iteration
  end
end

if teacher_mode
  puts "Behavior after evolution"
  world.create_generation
  world.populate
  world.enable_manual_iteration
  while true
    world.do_iteration
    iterations -= 1
  end
end
