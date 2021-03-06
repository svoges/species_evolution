require_relative 'matrix.rb'

class World
  # Instantiate a world object of length X_SIZE, height Y_SIZE.  If
  # MANUAL_MOVEMENT, the program will iterate through each person's movement.
  # If MANUAL_ITERATION, the program will iterate manually through each
  # iteration.
  def initialize(x_size, y_size, printing, manual_movement, manual_iteration)
    @manual_movement = manual_movement
    @manual_iteration = manual_iteration
    @printing = printing
    if manual_iteration or manual_movement
      @printing = true
    end
    # The length of the world.
    @x_size = x_size
    # the height of the world.
    @y_size = y_size
    # the total area of the world.
    @total_length = x_size * y_size
    # An array containing all current people in the world.
    @all_persons      = Array.new
    # An array containing all current monsters in the world.
    @all_monsters     = Array.new
    # An array containing all current mushrooms in the world.
    @all_mushrooms    = Array.new
    # An array containing all current strawberries in the world.
    @all_strawberries = Array.new
    # The current iteration of the world.
    @iteration = 0
    # The amount of turns monsters have to wait in order to move.
    @monster_iteration = 2
    # The current generation of the world.
    @generation = 0
    # The total amount of people that start each generation.
    @total_people = 0
  end

  # Populates the world according to the size of @TOTAL_LENGTH, and displays
  # the world afterwards.
  def populate
    if @total_length <= 25
      @total_people, total_strawberries = 3, 3
      total_monsters, total_mushrooms = 2, 2
    elsif @total_length <= 50
      @total_people, total_strawberries = 6, 6
      total_monsters, total_mushrooms = 3, 3
    elsif @total_length <= 100
      @total_people, total_strawberries = 9, 9
      total_monsters, total_mushrooms = 5, 5
    elsif @total_length <= 225
      @total_people, total_strawberries = 20, 20
      total_monsters, total_mushrooms = 7, 7
    elsif @total_length <= 1600
      @total_people, total_strawberries = 50, 50
      total_monsters, total_mushrooms = 10, 10
    else
      @total_people, total_strawberries = 300, 300
      total_monsters, total_mushrooms = 50, 50
    end

    while get_persons.size < @total_people
      add_person
    end
    while get_monsters.size < total_monsters
      add_monster
    end
    while get_strawberries.size < total_strawberries
      add_strawberry
    end
    while get_mushrooms.size < total_mushrooms
      add_mushroom
    end
  end

  # Main method controlling each iteration of the world.  People will move each
  # turn, and monsters will move after @MONSTER_ITERATION turns.
  def do_iteration
    @iteration += 1
    if @manual_iteration
      do_manual
    end
    persons_to_delete = Array.new
    @all_persons.each do |person|
      if @manual_movement
        puts do_manual
      end
      action = person.move(get_world_array, all_objects)
      if action[1] == 'eat'
        present_objects = get_objects_at_coord(person.get_x_location, person.get_y_location)
        present_objects.each do |food|
          if food != person
            if food.class == Strawberry
              person.eat
              food.decrement
              add_strawberry
              if food.get_amount <= 0
                @all_strawberries.delete(food)
              end
              puts "#{person} eats strawberry on square (#{person.get_x_location}, #{person.get_y_location})" if @printing
            elsif food.class == Mushroom
              persons_to_delete.push(person)
              food.decrement
              add_mushroom
              if food.get_amount <= 0
                @all_mushrooms.delete(food)
              end
              puts "#{person} eats mushroom on square (#{person.get_x_location}, #{person.get_y_location})" if @printing
            else
              puts "cannot eat #{food.class}"
              exit
            end
          end
        end
      elsif action[1] == 'ignore'
        person.move_random(get_world_array)
      elsif action[1] == 'towards'
        if action[0] == 3
          strawb = person.nearest_strawberry(all_objects)
          person.move_towards(get_world_array, strawb)
        elsif action[0] == 4
          mush = person.nearest_mushroom(all_objects)
          person.move_towards(get_world_array, mush)
        elsif action[0] == 5
          monster = person.nearest_monster(all_objects)
          person.move_towards(get_world_array, monster)
        elsif action[0] == 6
          creature = person.nearest_person(all_objects)
          person.move_towards(get_world_array, creature)
        else
          puts "invalid action: #{action}"
          exit
        end
      elsif action[1] == 'away_from'
        if action[0] == 3
          strawb = person.nearest_strawberry(all_objects)
          person.away_from(get_world_array, strawb)
        elsif action[0] == 4
          mush = person.nearest_mushroom(all_objects)
          person.away_from(get_world_array, mush)
        elsif action[0] == 5
          monster = person.nearest_monster(all_objects)
          person.away_from(get_world_array, monster)
        elsif action[0] == 6
          creature = person.nearest_person(all_objects)
          person.away_from(get_world_array, creature)
        else
          puts "invalid action: #{action}"
          exit
        end
      elsif action[1] == 'random'
        person.move_random(get_world_array)
      else
        puts "#{action} not a valid action"
        exit
      end

      if person.get_energy_level <= 0
        persons_to_delete.push(person)
        puts "#{person} dies from running out of energy" if @printing
      end

      present_objects = get_objects_at_coord(person.get_x_location, person.get_y_location)
      present_objects.each do |object|
        if object.class == Monster
          persons_to_delete.push(person)
          puts "#{person} moves to monster on square (#{person.get_x_location}, #{person.get_y_location})" if @printing
        end
      end
    end
    persons_to_delete.each do |person_to_delete|
      @all_persons.delete(person_to_delete)
    end

    if @iteration % @monster_iteration == 0
      @all_monsters.each do |monster|
        if @manual_movement
          do_manual
        end
        monster.move(get_world_array, all_objects)
        present_objects = get_objects_at_coord(monster.get_x_location, monster.get_y_location)
        if !present_objects.nil?
          present_objects.each do |object|
            if object != monster
              if object.class == Strawberry
                # do nothing
              elsif object.class == Mushroom
                # do nothing
              elsif object.class == Person
                @all_persons.delete(object)
                puts "Monster eats #{object} on square (#{monster.get_x_location}, #{monster.get_y_location})" if @printing
              else
                puts 'UNIDENTIFIED MONSTER OBJECT'
                exit
              end
            end
          end
        end
      end
    end
    display_world if @printing and !@manual_iteration
  end

  # Creates a generation of set size of initial input using tournament
  # selection and picking the best individual.
  def create_generation
    old_persons = Array.new(@all_persons)
    clear_world
    unless old_persons.empty?
      best_person = highest_fitness(old_persons)
      best_person.reset_energy_level
      @all_persons.push(best_person) unless best_person.nil?
      while @all_persons.size < @total_people and !old_persons.empty?
        if old_persons.size >= 10
          sample_size = 10
        elsif old_persons.size >= 5
          sample_size = 5
        else
          sample_size = 3
        end
        sample_one = old_persons.sample(sample_size)
        sample_two = old_persons.sample(sample_size)

        parent_one = highest_fitness(sample_one)
        parent_two = highest_fitness(sample_two)

        old_persons.delete_if { |x| x == parent_one or x == parent_two }
        (0..1).each do
          coords = get_empty_coords
          new_person = Person.new(coords[0], coords[1], @x_size, @y_size, parent_one.get_chromosome, parent_two.get_chromosome)
          @all_persons.push(new_person)
        end
      end
    end
    @generation += 1
  end

  # Returns the BEST_PERSON according to energy level of the SAMPLE_GROUP.
  def highest_fitness(sample_group)
    best_fitness = 0
    best_person = nil
    sample_group.each do |person|
      if person.get_energy_level > best_fitness
        best_person = person
        best_fitness = person.get_energy_level
      end
    end
    best_person
  end

  # Write all necessary information to output files.
  def generate_output
    write_average_fitness('output/average.txt')
    write_best_fitness('output/best.txt')
    write_survivors('output/survivors.txt')
    write_traits('output/traits.txt')
  end

  # Write the traits of each person to OUTPUT_FILE.
  def write_traits(output_file)
    open(output_file, 'a') { |f|
      f.puts "=========#{@generation}========"
      @all_persons.each do |person|
        f.puts "#{person.get_chromosome.get_sequence}"
      end
    }
  end

  # Write the average fitness of the generation to the OUTPUT_FILE.
  def write_average_fitness(output_file)
    open(output_file, 'a') { |f|
      f.puts "#{@generation} #{average_fitness}\n"
    }
  end

  # Write the average fitness of the generation to the OUTPUT_FILE.
  def write_best_fitness(output_file)
    open(output_file, 'a') { |f|
      if !@all_persons.empty?
        f.puts "#{@generation} #{highest_fitness(@all_persons).get_energy_level}\n"
      else
        f.puts "#{@generation} 0\n"
      end
    }
  end

  # Write the average fitness of the generation to the OUTPUT_FILE.
  def write_survivors(output_file)
    open(output_file, 'a') { |f|
      f.puts "#{@generation} #{@all_persons.size}\n"
    }
  end

  # Return the average fitness according to energy level of the generation.
  def average_fitness
    total_fitness = 0
    @all_persons.each do |person|
      total_fitness += person.get_energy_level
    end
    if @all_persons.empty?
      return 0
    else
      total_fitness / @total_people
    end
  end

  # Display the energy level of each person in the world.
  def group_fitness
    unless @all_persons.empty?
      @all_persons.each do |person|
        puts "#{person}: #{person.get_energy_level}"
      end
    end
  end

  # Displays the world, then waits for input from the user to continue.
  def do_manual
    display_world
    puts "Press enter to continue"
    STDOUT.flush
    input = STDIN.gets.chomp
    if input == "quit" or input == "exit"
      exit
    end
  end

  # Returns a 2-dimensional representation of the world, WORLD_ARRAY, with each
  # space represented as an array holding its objects.
  def get_world_array
    world_array = Array.new(@total_length){ [] }

    @all_strawberries.each do |strawberry|
      world_array[Matrix.two_to_one(strawberry.get_x_location, strawberry.get_y_location, @x_size)].push(strawberry)
    end
    @all_mushrooms.each do |mushroom|
      world_array[Matrix.two_to_one(mushroom.get_x_location, mushroom.get_y_location, @x_size)].push(mushroom)
    end
    @all_persons.each do |person|
      world_array[Matrix.two_to_one(person.get_x_location, person.get_y_location, @x_size)].push(person)
    end
    @all_monsters.each do |monster|
      world_array[Matrix.two_to_one(monster.get_x_location, monster.get_y_location, @x_size)].push(monster)
    end
    world_array
  end

  # Print a 2-dimensional representation of the world to the screen.
  def display_world
    Matrix.draw_matrix(get_world_array, @x_size, @y_size)
  end

  # Clear all objects from the world.
  def clear_world
    @all_persons.clear
    @all_monsters.clear
    @all_strawberries.clear
    @all_mushrooms.clear

    @iteration = 0
  end

  # Display the coordinates of each object in the world.
  def display_coordinates
    puts 'persons'
    @all_persons.each do |person|
      puts "X: #{person.get_x_location} \nY: #{person.get_y_location}\n"
    end
    puts 'MONSTERS'
    @all_monsters.each do |monster|
      puts "X: #{monster.get_x_location} \nY: #{monster.get_y_location}\n"
    end
    puts 'STRAWBERRIES'
    @all_strawberries.each do |strawberry|
      puts "X: #{strawberry.get_x_location} \nY: #{strawberry.get_y_location}\n"
    end
    puts 'MUSHROOMS'
    @all_mushrooms.each do |mushroom|
      puts "X: #{mushroom.get_x_location} \nY: #{mushroom.get_y_location}\n"
    end
  end

  # Get the person located at X_LOCATION, Y_LOCATION
  def get_person(x_location, y_location)
    @all_persons.each do |person|
      if person.get_x_location == x_location and person.get_y_location == y_location
        return person
      else
        return nil
      end
    end
  end

  # Returns the object at coordinate X_LOCATION, Y_LOCATION.
  def get_objects_at_coord(x_location, y_location)
    get_world_array[Matrix.two_to_one(x_location, y_location, @x_size)]
  end

  # Returns a hash of all the objects in the world.
  def all_objects
    objects = {
    "Strawberries" => get_strawberries,
    "Mushrooms"    => get_mushrooms,
    "Monsters"     => get_monsters,
    "Persons"      => get_persons
    }
  end

  # Returns a pair of [X, Y] coordinates that are currently empty in the world.
  def get_empty_coords
    good_coords = false
    curr_world = get_world_array
    objects = all_objects
    number_of_objects = all_objects["Strawberries"].size + all_objects["Persons"].size + all_objects["Monsters"].size + all_objects["Mushrooms"].size
    if number_of_objects == @total_length
      puts 'INPUT BIGGER MATRIX'
      exit
    end
    while !good_coords
      x_coord = rand(@x_size)
      y_coord = rand(@y_size)
      if curr_world[Matrix.two_to_one(x_coord, y_coord, @x_size)].empty?
        good_coords = true
      end
    end
    [x_coord, y_coord]
  end

  # Add a person to the world in a random place.
  def add_person
    coord = get_empty_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_person = Person.new(x_coord, y_coord, @x_size, @y_size)
    @all_persons.push(new_person)
  end

  # Add a person to the world at X_COORD, Y_COORD
  def add_person_coordinate(x_coord, y_coord)
    new_person = Person.new(x_coord, y_coord, @x_size, @y_size)
    @all_persons.push(new_person)
  end

  # Add a monster to the world in a random place.
  def add_monster
    coord = get_empty_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_monster = Monster.new(x_coord, y_coord, @x_size, @y_size)
    @all_monsters.push(new_monster)
  end

  # Add a monster to the world at X_COORD, Y_COORD
  def add_monster_coordinate(x_coord, y_coord)
    new_monster = Monster.new(x_coord, y_coord, @x_size, @y_size)
    @all_monsters.push(new_monster)
  end

  # Add a strawberry to the world in a random place.
  def add_strawberry
    coord = get_empty_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_strawberry = Strawberry.new(x_coord, y_coord)
    @all_strawberries.push(new_strawberry)
  end

  # Add a strawberry to the world at X_COORD, Y_COORD
  def add_strawberry_coordinate(x_coord, y_coord)
    strawberry_exists = false
    @all_strawberries.each do |strawberry|
      if Matrix.two_to_one(strawberry.get_x_location, strawberry.get_y_location , @x_size) == Matrix.two_to_one(x_coord, y_coord, @x_size)
        strawberry.increment
        strawberry_exists = true
      end
    end
    if !strawberry_exists
      new_strawberry = Strawberry.new(x_coord, y_coord)
      @all_strawberries.push(new_strawberry)
    end
  end

  # Add a mushroom to the world in a random place.
  def add_mushroom
    coord = get_empty_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_mushroom = Mushroom.new(x_coord, y_coord)
    @all_mushrooms.push(new_mushroom)
  end

  # Add a mushroom to the world at X_COORD, Y_COORD
  def add_mushroom_coordinate(x_coord, y_coord)
    new_mushroom = Mushroom.new(x_coord, y_coord)
    @all_mushrooms.push(new_mushroom)
  end

  # Returns the current generation of the world.
  def get_generation
    @generation
  end

  # Returns an array containing all strawberries in the world.
  def get_strawberries
    @all_strawberries
  end

  # Returns an array containing all mushrooms in the world.
  def get_mushrooms
    @all_mushrooms
  end

  # Returns an array containing all monsters in the world.
  def get_monsters
    @all_monsters
  end

  # Returns an array containing all persons in the world.
  def get_persons
    @all_persons
  end

  def enable_manual_iteration
    @manual_iteration = true
    @printing = true
  end
end
