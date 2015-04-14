require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'


if ARGV.length != 2
  puts "ERROR: Need 2 inputs for x and y values of array"
  exit
else
  $x_size = ARGV[0].to_i
  $y_size = ARGV[1].to_i
  $total_length = $x_size * $y_size
end

$coords_used = []
def get_coords()
  good_coords = false
  while !good_coords
    x_coord = rand($x_size)
    y_coord = rand($y_size)
    if !$coords_used.include?([x_coord, y_coord])
      $coords_used.push([x_coord, y_coord])
      good_coords = true
    end
  end
  [x_coord, y_coord]
end

# Ask questions about regeneration/number of monsters, strawberries and mushrooms
# Create $x_size by $y_size arrays for storage of different objects
all_creatures    = Array.new
all_monsters     = Array.new
all_mushrooms    = Array.new
all_strawberries = Array.new

def create_world_array(creatures, monsters, mushrooms, strawberries)
  world_array = Array.new($total_length){ nil }

  creatures.each do |creature|
    world_array[Matrix.two_to_one(creature.get_x_location, creature.get_y_location, $x_size)] = creature
  end
  monsters.each do |monster|
    world_array[Matrix.two_to_one(monster.get_x_location, monster.get_y_location, $x_size)] = monster
  end
  strawberries.each do |strawberry|
    world_array[Matrix.two_to_one(strawberry.get_x_location, strawberry.get_y_location, $x_size)] = strawberry
  end
  mushrooms.each do |mushroom|
    world_array[Matrix.two_to_one(mushroom.get_x_location, mushroom.get_y_location, $x_size)] = mushroom
  end
  world_array
end


# Create creatures. population could be done better
(0..2).each do |creature|
  coord = get_coords()
  x_coord = coord[0]
  y_coord = coord[1]

  new_creature = Creature.new(x_coord, y_coord)
  all_creatures.push(new_creature)
end

(0..2).each do |monster|
  coord = get_coords()
  x_coord = coord[0]
  y_coord = coord[1]

  new_monster = Monster.new(x_coord, y_coord)
  all_monsters.push(new_monster)
end

(0..1).each do |strawberry|
  coord = get_coords()
  x_coord = coord[0]
  y_coord = coord[1]

  new_strawberry = Strawberry.new(x_coord, y_coord)
  all_strawberries.push(new_strawberry)
end

(0..1).each do |mushroom|
  coord = get_coords()
  x_coord = coord[0]
  y_coord = coord[1]

  new_mushroom = Mushroom.new(x_coord, y_coord)
  all_mushrooms.push(new_mushroom)
end

world_array = create_world_array(all_creatures, all_monsters, all_mushrooms, all_strawberries)
Matrix.draw_matrix(world_array, $x_size, $y_size)
