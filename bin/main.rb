require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'
require_relative '../lib/world.rb'

if ARGV.length < 2
  if ARGV.include?('-help')
    puts "Help information for Evolve a Species Project"
    puts "Usage: ruby [x_location] [y_location] [options]"
    puts "   -i      enable manual printing after each iteration, 'exit' or 'quit' to abort"
    puts "   -m      enable manual printing after each movement, 'exit' or 'quit' to abort"
    puts "   -g      enable generations mode"
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
  # if true, enables generational mode in which evolution will occur
  generations = false
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
  world = World.new(ARGV[0].to_i, ARGV[1].to_i, manual_movement, manual_iteration)
end
world = World.new(ARGV[0].to_i, ARGV[1].to_i, manual_movement, manual_iteration)

generations = true
if generations
  File.truncate('output/average.txt', 0)
  File.truncate('output/best.txt', 0)
  File.truncate('output/survivors.txt', 0)
  STDOUT.flush
  # while next_gen = STDIN.gets.chomp
  #   if next_gen == "quit" or next_gen == "exit"
  #     exit
  #   end`
  while world.get_generation < 200
    world.create_generation
    if world.get_generation % 1 == 0
      puts "======================#{world.get_generation}============================"
    end
    world.populate
    iterations = 25
    while iterations > 0
      world.do_iteration
      iterations -= 1
    end
    world.write_average_fitness('output/average.txt')
    world.write_best_fitness('output/best.txt')
    world.write_survivors('output/survivors.txt')
    # puts "Average fitness after iterations: #{world.average_fitness}"
    # puts "Each person's fitness after iterations"
  end
  world.get_persons.each do |person|
    puts person.get_chromosome.get_sequence
  end
  world.group_fitness
else
  # Create creatures
  world.populate
  while !world.get_persons.empty?
    world.do_iteration
  end
end
