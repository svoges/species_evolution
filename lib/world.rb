require_relative 'matrix.rb'

class World
  def initialize(x_size, y_size)
    @x_size = x_size
    @y_size = y_size
    @total_length = x_size * y_size
    @coords_used = []
    @all_persons     = Array.new
    @all_monsters     = Array.new
    @all_mushrooms    = Array.new
    @all_strawberries = Array.new
  end

  def initialize_world
    (0..2).each { add_person }
    (0..2).each { add_monster }
    (0..1).each { add_strawberry }
    (0..1).each { add_mushroom }
    display_world
  end

  # Do random movements for the persons at first
  def do_iteration
    @all_persons.each do |person|
      person.move_random
      present_objects = get_objects_at_coord(person.get_x_location, person.get_y_location)
      if !present_objects.nil?
        present_objects.each do |object|
          if object != person
            if object.class == Strawberry
              person.eat
              object.decrement
              if object.get_amount <= 0
                @all_strawberries.delete(object)
              end
            elsif object.class == Mushroom
              @all_persons.delete(person)
              object.decrement
              if object.get_amount <= 0
                @all_mushrooms.delete(object)
              end
            elsif object.class == Monster
              @all_persons.delete(person)
            else
              puts 'UNIDENTIFIED PERSON OBJECT'
              exit
            end
          end
        end
      end
    end
    display_world
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

  def get_coords
    good_coords = false
    curr_world = get_world_array
    while !good_coords
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
    coord = get_coords()
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
    coord = get_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_monster = Monster.new(x_coord, y_coord, @x_size, @y_size)
    @all_monsters.push(new_monster)
  end

  def add_strawberry
    coord = get_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_strawberry = Strawberry.new(x_coord, y_coord)
    @all_strawberries.push(new_strawberry)
  end

  def add_strawberry_coordinate(x_coord, y_coord)
    new_strawberry = Strawberry.new(x_coord, y_coord)
    @all_strawberries.push(new_strawberry)
  end

  def add_mushroom
    get_coords_used
    coord = get_coords()
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
