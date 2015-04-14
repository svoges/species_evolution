require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'


if ARGV.length != 2
  puts "ERROR: Need 2 inputs for x and y values of array"
  exit
else
  $x_size = ARGV[0].to_i
  $y_size = ARGV[1].to_i
  total_length = $x_size * $y_size
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
world_array = Array.new(total_length){ 0 }

strawberry_array  = Array.new(total_length){ 0 }
mushroom_array    = Array.new(total_length){ 0 }
creature_array    = Array.new(total_length){ 0 }
monster_array     = Array.new(total_length){ 0 }

all_creatures    = Array.new
all_monsters     = Array.new
all_strawberries = Array.new
all_mushrooms    = Array.new


# Create creatures. population could be done better
(0..2).each do |creature|
  coord = get_coords()
  x_coord = coord[0]
  y_coord = coord[1]

  new_creature = Creature.new(x_coord, y_coord)
  all_creatures.push(new_creature)
  creature_array[Matrix.two_to_one(x_coord, y_coord, $x_size)] = new_creature
end

(0..2).each do |monster|
  coord = get_coords()
  x_coord = coord[0]
  y_coord = coord[1]

  new_monster = Monster.new(x_coord, y_coord)
  all_monsters.push(new_monster)
  monster_array[Matrix.two_to_one(x_coord, y_coord, $x_size)] = new_monster
end

(0..1).each do |strawberry|
  coord = get_coords()
  x_coord = coord[0]
  y_coord = coord[1]

  new_strawberry = Strawberry.new(x_coord, y_coord)
  all_strawberries.push(new_strawberry)
  strawberry_array[Matrix.two_to_one(x_coord, y_coord, $x_size)] = new_strawberry
end

(0..1).each do |mushroom|
  coord = get_coords()
  x_coord = coord[0]
  y_coord = coord[1]

  new_mushroom = Mushroom.new(x_coord, y_coord)
  all_mushrooms.push(new_mushroom)
  mushroom_array[Matrix.two_to_one(x_coord, y_coord, $x_size)] = new_mushroom

end

Matrix.draw_matrix(strawberry_array, $x_size, $y_size)
Matrix.draw_matrix(mushroom_array, $x_size, $y_size)
Matrix.draw_matrix(monster_array, $x_size, $y_size)
Matrix.draw_matrix(creature_array, $x_size, $y_size)
