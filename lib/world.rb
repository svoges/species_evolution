require_relative 'matrix.rb'

class World
  def initialize(x_size, y_size)
    @x_size = x_size
    @y_size = y_size
    @total_length = x_size * y_size
    @coords_used = []
    @all_creatures    = Array.new
    @all_monsters     = Array.new
    @all_mushrooms    = Array.new
    @all_strawberries = Array.new
  end

  def initialize_world
    (0..2).each { add_creature }
    (0..2).each { add_monster }
    (0..1).each { add_strawberry }
    (0..1).each { add_mushroom }
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
      if curr_world[Matrix.two_to_one(x_coord, y_coord, @x_size)].nil?
        @coords_used.push([x_coord, y_coord])
        good_coords = true
      end
    end
    [x_coord, y_coord]
  end

  def get_world_array
    world_array = Array.new(@total_length){ nil }

    @all_creatures.each do |creature|
      world_array[Matrix.two_to_one(creature.get_x_location, creature.get_y_location, @x_size)] = creature
    end
    @all_monsters.each do |monster|
      world_array[Matrix.two_to_one(monster.get_x_location, monster.get_y_location, @x_size)] = monster
    end
    @all_strawberries.each do |strawberry|
      world_array[Matrix.two_to_one(strawberry.get_x_location, strawberry.get_y_location, @x_size)] = strawberry
    end
    @all_mushrooms.each do |mushroom|
      world_array[Matrix.two_to_one(mushroom.get_x_location, mushroom.get_y_location, @x_size)] = mushroom
    end
    world_array
  end

  def display_world
    Matrix.draw_matrix(get_world_array, @x_size, @y_size)
  end

  def add_creature
    coord = get_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_creature = Creature.new(x_coord, y_coord)
    @all_creatures.push(new_creature)
  end

  def add_monster
    coord = get_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_monster = Monster.new(x_coord, y_coord)
    @all_monsters.push(new_monster)
  end

  def add_strawberry
    coord = get_coords()
    x_coord = coord[0]
    y_coord = coord[1]

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

  def display_coordinates
    puts "CREATURES"
    @all_creatures.each do |creature|
      puts "X: #{creature.get_x_location} \nY: #{creature.get_y_location}\n"
    end
    puts "MONSTERS"
    @all_monsters.each do |monster|
      puts "X: #{monster.get_x_location} \nY: #{monster.get_y_location}\n"
    end
    puts "STRAWBERRIES"
    @all_strawberries.each do |strawberry|
      puts "X: #{strawberry.get_x_location} \nY: #{strawberry.get_y_location}\n"
    end
    puts "MUSHROOMS"
    @all_mushrooms.each do |mushroom|
      puts "X: #{mushroom.get_x_location} \nY: #{mushroom.get_y_location}\n"
    end
  end
end
