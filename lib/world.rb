require_relative 'matrix.rb'

class World
  def initialize(x_size, y_size, manual_movement, manual_iteration)
    @manual_movement = manual_movement
    if @manual_movement
      puts "MANUAL MOVEMENT ENABLED"
    end
    @manual_iteration = manual_iteration
    if @manual_iteration
      puts "MANUAL ITERATION ENABLED"
    end
    @x_size = x_size
    @y_size = y_size
    @total_length = x_size * y_size
    @coords_used = []
    @all_persons      = Array.new
    @all_monsters     = Array.new
    @all_mushrooms    = Array.new
    @all_strawberries = Array.new
    @iteration = 0
    @monster_iteration = 3
    @strawberry_iteration = 5
  end

  def initialize_world
    (0..2).each { add_person }
    (0..2).each { add_monster }
    (0..1).each { add_strawberry }
    (0..1).each { add_mushroom }
    display_world
  end

  def do_manual
    display_world
    puts "Press enter to continue"
    STDOUT.flush
    input = STDIN.gets.chomp
    if input == "quit" or input == "exit"
      exit
    end
  end

  # Do random movements for the persons at first
  def do_iteration
    puts "--------#{@iteration}--------"
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
            elsif food.class == Mushroom
              persons_to_delete.push(person)
              food.decrement
              add_mushroom
              if food.get_amount <= 0
                @all_mushrooms.delete(food)
              end
              puts "Person ate mushroom on square (#{person.get_x_location}, #{person.get_y_location})"
            else
              puts "cannot eat #{food.class}"
            end
          end
        end
      elsif action[1] == 'ignore'
        # do nothing or move randomly
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
        end
      elsif action[1] == 'random'
        person.move_random(get_world_array)
      else
        puts "#{action} not a valid action"
      end

      if person.get_energy_level <= 0
        persons_to_delete.push(person)
      end

      present_objects = get_objects_at_coord(person.get_x_location, person.get_y_location)
      present_objects.each do |object|
        if object.class == Monster
          persons_to_delete.push(person)
          puts "Person moved to monster on square (#{person.get_x_location}, #{person.get_y_location})"
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
                puts "Monster ate person on square (#{monster.get_x_location}, #{monster.get_y_location})"
              else
                puts 'UNIDENTIFIED MONSTER OBJECT'
                exit
              end
            end
          end
        end
      end
    end
    if @iteration % @strawberry_iteration == 0
      add_strawberry
    end
    puts @all_persons
    display_world
  end

  def all_objects
    objects = {
    "Strawberries" => get_strawberries,
    "Mushrooms"    => get_mushrooms,
    "Monsters"     => get_monsters,
    "Persons"      => get_persons
    }
  end

  # Split the chromosomes in half and choose from existing people.  Possibly
  # introduce a mutation
  def merge_people(person_one, person_two)
  end

  def get_strawberries
    @all_strawberries
  end

  def get_mushrooms
    @all_mushrooms
  end

  def get_monsters
    @all_monsters
  end

  def get_persons
    @all_persons
  end

  def get_coords_used
    @coords_used
  end

  def get_empty_coords
    good_coords = false
    curr_world = get_world_array
    while !good_coords
      if @total_length == @coords_used.size
        puts 'INPUT BIGGER MATRIX'
        exit
      end
      x_coord = rand(@x_size)
      y_coord = rand(@y_size)
      if curr_world[Matrix.two_to_one(x_coord, y_coord, @x_size)].empty?
        @coords_used.push([x_coord, y_coord])
        good_coords = true
      end
    end
    [x_coord, y_coord]
  end

  def get_objects_at_coord(x_location, y_location)
    get_world_array[Matrix.two_to_one(x_location, y_location, @x_size)]
  end

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

  def display_world
    Matrix.draw_matrix(get_world_array, @x_size, @y_size)
  end

  def add_person_coordinate(x_coord, y_coord)
    new_person = Person.new(x_coord, y_coord, @x_size, @y_size)
    @all_persons.push(new_person)
  end

  def add_person
    coord = get_empty_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_person = Person.new(x_coord, y_coord, @x_size, @y_size)
    @all_persons.push(new_person)
  end

  def get_person(x_location, y_location)
    @all_persons.each do |person|
      if person.get_x_location == x_location and person.get_y_location == y_location
        return person
      else
        return nil
      end
    end
  end

  def add_monster
    coord = get_empty_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_monster = Monster.new(x_coord, y_coord, @x_size, @y_size)
    @all_monsters.push(new_monster)
  end

  def add_monster_coordinate(x_coord, y_coord)
    new_monster = Monster.new(x_coord, y_coord, @x_size, @y_size)
    @all_monsters.push(new_monster)
  end

  def add_strawberry
    coord = get_empty_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_strawberry = Strawberry.new(x_coord, y_coord)
    @all_strawberries.push(new_strawberry)
  end

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

  def add_mushroom
    coord = get_empty_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_mushroom = Mushroom.new(x_coord, y_coord)
    @all_mushrooms.push(new_mushroom)
  end

  def add_mushroom_coordinate(x_coord, y_coord)
    new_mushroom = Mushroom.new(x_coord, y_coord)
    @all_mushrooms.push(new_mushroom)
  end

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
end
