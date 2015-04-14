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

  def get_coords
    good_coords = false
    while !good_coords
      x_coord = rand(@x_size)
      y_coord = rand(@y_size)
      if !@coords_used.include?([x_coord, y_coord])
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
    coord = get_coords()
    x_coord = coord[0]
    y_coord = coord[1]

    new_mushroom = Mushroom.new(x_coord, y_coord)
    @all_mushrooms.push(new_mushroom)
  end
end
