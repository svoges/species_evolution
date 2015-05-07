# The parent class for MONSTER and PERSON.
class Creature
  def initialize(x, y, x_size, y_size)
    # The x coordinate of the creature.
    @x_location = x
    # The y coordinate of the creature.
    @y_location = y
    # The length of the world.
    @x_size = x_size
    # The height of the world.
    @y_size = y_size
    # The total area of the world.
    @total_length = x_size * y_size
    # The string representation of the creature.
    @type = 'Creature'
  end

  # Move randomly in the world_array.
  def move_random(world_array)
    good_movement = false
    while !good_movement
      movement = rand(4)
      good_movement = true
      if movement == 0 and can_move_south(world_array)
        move_south(world_array)
      elsif movement == 1 and can_move_west(world_array)
        move_west(world_array)
      elsif movement == 2 and can_move_north(world_array)
        move_north(world_array)
      elsif movement == 3 and can_move_east(world_array)
        move_east(world_array)
      elsif no_possible_moves(world_array)
        # do nothing
      else
        good_movement = false
      end
    end
  end

  # Move the creature north.
  def move_north(world_array)
    if can_move_north(world_array)
      @y_location -= 1
    else
      puts "ERROR: #{@type} illegally moved north"
      exit
    end
  end

  # Move the creature south.
  def move_south(world_array)
    if can_move_south(world_array)
      @y_location += 1
    else
      puts "ERROR: #{@type} illegally moved south"
      exit
    end
  end

  # Move the creature east.
  def move_east(world_array)
    if can_move_east(world_array)
      @x_location += 1
    else
      puts "ERROR: #{@type} illegally moved east"
      exit
    end
  end

  # Move the creature west.
  def move_west(world_array)
    if can_move_west(world_array)
      @x_location -= 1
    else
      puts "ERROR: #{@type} illegally moved west"
      exit
    end
  end

  # Return TRUE if the creature can move north in WORLD_ARRAY, else FALSE.
  def can_move_north(world_array)
    objects = objects_north(world_array)
    if !objects.nil?
      objects.each do |object|
        if object.class == self.class
          return false
        end
      end
    end
    if get_single_coord < @x_size
      return false
    else
      return true
    end
  end

  # Return TRUE if the creature can move west in WORLD_ARRAY, else FALSE.
  def can_move_west(world_array)
    objects = objects_west(world_array)
    if !objects.nil?
      objects.each do |object|
        if object.class == self.class
          return false
        end
      end
    end
    if get_single_coord % @x_size == 0
      return false
    else
      return true
    end
  end

  # Return TRUE if the creature can move south in WORLD_ARRAY, else FALSE.
  def can_move_south(world_array)
    objects = objects_south(world_array)
    if !objects.nil?
      objects.each do |object|
        if object.class == self.class
          return false
        end
      end
    end
    if @total_length - get_single_coord <= @x_size
      return false
    else
      return true
    end
  end

  # Return TRUE if the creature can move east in WORLD_ARRAY, else FALSE.
  def can_move_east(world_array)
    objects = objects_east(world_array)
    if !objects.nil?
      objects.each do |object|
        if object.class == self.class
          return false
        end
      end
    end
    if get_single_coord % @x_size == @x_size - 1
      return false
    else
      return true
    end
  end

  # Returns the objects north of a creature in WORLD_ARRAY.
  def objects_north(world_array)
    coordinate = Matrix.two_to_one(@x_location, @y_location - 1, @x_size)
    return world_array[coordinate]
  end

  # Returns the objects west of a creature in WORLD_ARRAY.
  def objects_west(world_array)
    coordinate = Matrix.two_to_one(@x_location - 1, @y_location, @x_size)
    return world_array[coordinate]
  end

  # Returns the objects east of a creature in WORLD_ARRAY.
  def objects_east(world_array)
    coordinate = Matrix.two_to_one(@x_location + 1, @y_location, @x_size)
    return world_array[coordinate]
  end

  # Returns the objects south of a creature in WORLD_ARRAY.
  def objects_south(world_array)
    coordinate = Matrix.two_to_one(@x_location, @y_location + 1, @x_size)
    return world_array[coordinate]
  end

  # Display the possible movements of the creature. Used for testing. A
  # creature can move in a direction if the space does not contain a creature
  # of the same class.
  def movements
    puts "North #{can_move_north}"
    puts "South #{can_move_south}"
    puts "East #{can_move_east}"
    puts "West #{can_move_west}"
  end

  # Return FALSE if there are no possible moves for the creature, else TRUE.
  def no_possible_moves(world_array)
    !(can_move_west(world_array) or can_move_east(world_array) or can_move_north(world_array) or can_move_south(world_array))
  end

  # Return the single coordinate representation of the creature's location.
  def get_single_coord
    Matrix.two_to_one(@x_location, @y_location, @x_size)
  end

  # Return the @X_LOCATION of the creature.
  def get_x_location
    @x_location
  end

  # Return the @Y_LOCATION of the creature.
  def get_y_location
    @y_location
  end

  # Set the @X_LOCATION of the creature.
  def set_x_location(location)
    @x_location = location
  end

  # Set the @Y_LOCATION of the creature.
  def set_y_location(location)
    @y_location = location
  end
end

# Contains variables and methods for a PERSON's CHROMOSOME.
class Chromosome
  # If CHROMOSOME_ONE and CHROMOSMOE_TWO are given, initialize the new
  # chromosome using a crossover of the two sequences.
  def initialize(chromosome_one=nil, chromosome_two=nil)
    if chromosome_one and chromosome_two
      sequence_one = chromosome_one.get_sequence
      sequence_two = chromosome_two.get_sequence
      # A hash containing all actions and weights.
      # 1 => action to do when strawberry is present.
      # 2 => action to do when mushroom is present.
      # 3 => action to do on closest strawberry.
      # 4 => action to do on closest mushroom.
      # 5 => action to do on closest monster.
      # 6 => action to do on closest creature.
      @sequence = {}
      position = 1
      (1..6).each do
        person = rand(2)
        if person == 0
          @sequence[position] = sequence_one[position]
        else
          @sequence[position] = sequence_two[position]
        end
        position += 1
      end
      if introduce_mutation
        do_mutation
      end
    elsif sequence_one or sequence_two
      puts "ONLY ONE SEQUENCE GIVEN"
      exit
    else
      @sequence = {
        1 => [eat_or_ignore, rand(100)],
        2 => [eat_or_ignore, rand(100)],
        3 => [movement,      rand(100)],
        4 => [movement,      rand(100)],
        5 => [movement,      rand(100)],
        6 => [movement,      rand(100)]
      }
    end
  end

  # Get a random movement action for the position of a chromosome.
  def movement
    action = rand(4)
    if action == 0
      return 'towards'
    elsif action == 1
      return 'away_from'
    elsif action == 2
      return 'random'
    elsif action == 3
      return 'ignore'
    else
      puts "RANDOM FUNCTION INCORRECT"
      exit
    end
  end

  # Get a random eating action for the position of a chromosome.
  def eat_or_ignore
    action = rand(2)
    if action == 0
      return 'eat'
    elsif action == 1
      return 'ignore'
    else
      puts "RANDOM FUNCTION INCORRECT"
      exit
    end
  end

  # Introduce a mutation in the sequence at a random position.
  def do_mutation
    position = rand(1..6)
    if position > 2
      @sequence[position] = [movement, rand(100)]
    else
      @sequence[position] = [eat_or_ignore, rand(100)]
    end
  end

  # Mutate the sequence with probability 1/7.
  def introduce_mutation
    if rand(8) == 1
      return true
    else
      return false
    end
  end

  # Set the POSITION at SEQUENCE to weight VALUE.
  def set_position(position, value)
    @sequence[position] = value
  end

  # Return @SEQUENCE.
  def get_sequence
    @sequence
  end

  # Get the weight for position 1.
  def get_strawb_present_weight
    @sequence[1][1]
  end

  # Get the weight for position 2.
  def get_mush_present_weight
    @sequence[2][1]
  end

  # Get the weight for position 3.
  def get_nearest_strawb_weight
    @sequence[3][1]
  end

  # Get the weight for position 4.
  def get_nearest_mush_weight
    @sequence[4][1]
  end

  # Get the weight for position 5.
  def get_nearest_monster_weight
    @sequence[5][1]
  end

  # Get the weight for position 6.
  def get_nearest_person_weight
    @sequence[6][1]
  end
end

class Person < Creature
  def initialize(x, y, x_size, y_size, chromosome_one=nil, chromosome_two=nil)
    # The x coordinate of the person.
    @x_location = x
    # The y coordinate of the person.
    @y_location = y
    # The length of the world.
    @x_size = x_size
    # The height of the world.
    @y_size = y_size
    # The total area of the world.
    @total_length = x_size * y_size
    # The string representation of the person.
    @type = 'Person'
    # The energy level of the person.
    @energy_level = 25
    # The chromomome of the person dictating actions based on surroundings.
    @chromosome = Chromosome.new(chromosome_one, chromosome_two)
  end

  # Main function for executing a person's action, based on the best role and
  # its corresponding action.
  def move(world_array, all_objects)
    # Find the most weighted applicable position in the chromosome
    role = best_role(all_objects)
    # Get the action corresponding to this position
    action = get_action(role)
    @energy_level -= 1
    action
  end

  # Finds the best role in the chromosome based on the maximum weight of
  # applicable roles.
  def best_role(all_objects)
    max_weight = 0
    role = nil
    if strawberry_present(all_objects)
      new_weight = @chromosome.get_strawb_present_weight
      if new_weight > max_weight
        max_weight = new_weight
        role = 1
      end
    end

    if mushroom_present(all_objects)
      new_weight = @chromosome.get_mush_present_weight
      if new_weight > max_weight
        max_weight = new_weight
        role = 2
      end
    end

    if !all_objects["Strawberries"].empty?
      if Matrix.euclidean_distance(self, nearest_strawberry(all_objects)) < 3
        new_weight = @chromosome.get_nearest_strawb_weight
        if new_weight > max_weight
          max_weight = new_weight
          role = 3
        end
      end
    end

    if !all_objects["Mushrooms"].empty?
      if Matrix.euclidean_distance(self, nearest_mushroom(all_objects)) < 3
        new_weight = @chromosome.get_nearest_mush_weight
        if new_weight > max_weight
          max_weight = new_weight
          role = 4
        end
      end
    end

    if !all_objects["Monsters"].empty?
      if Matrix.euclidean_distance(self, nearest_monster(all_objects)) < 3
        new_weight = @chromosome.get_nearest_monster_weight
        if new_weight > max_weight
          max_weight = new_weight
          role = 5
        end
      end
    end

    all_people = all_objects["Persons"].reject { |person| person == self }
    if !all_people.empty?
      closest_person = nearest_person(all_objects)
      if Matrix.euclidean_distance(self, closest_person) < 3
        new_weight = @chromosome.get_nearest_person_weight
        if new_weight > max_weight
          max_weight = new_weight
          role = 6
        end
      end
    end
    role
  end

  # Returns a pairing of [position, action] from the chromosome.
  def get_action(role)
    if role
      return [role, @chromosome.get_sequence[role][0]]
    else
      return [role, 'random']
    end
  end

  # Move away from TARGET in the WORLD ARRAY based on euclidean distance.
  def away_from(world_array, target)
    if target
      current_distance = Matrix.euclidean_distance(self, target)
      target_coords = [target.get_x_location, target.get_y_location]

      distance_east  = Matrix.coord_euclidean_distance([[@x_location + 1, @x_size - 1].min, @y_location], target_coords)
      distance_west  = Matrix.coord_euclidean_distance([[@x_location - 1, 0].max, @y_location], target_coords)
      distance_north = Matrix.coord_euclidean_distance([@x_location, [@y_location - 1, 0].max], target_coords)
      distance_south = Matrix.coord_euclidean_distance([@x_location, [@y_location + 1, @y_size - 1].min], target_coords)

      if current_distance >= [distance_east, distance_south, distance_west, distance_north].max
        # puts "cannot move further away from target"
      else
        used_movements = []
        good_movement = false
        while !good_movement
          movement = rand(4)
          used_movements.push(movement)
          if movement == 0
            if can_move_east(world_array) and distance_east > current_distance
              move_east(world_array)
              good_movement = true
            end
          elsif movement == 1
            if can_move_west(world_array) and distance_west > current_distance
              move_west(world_array)
              good_movement = true
            end
          elsif movement == 2
            if can_move_north(world_array) and distance_north > current_distance
              move_north(world_array)
              good_movement = true
            end
          elsif movement == 3
            if can_move_south(world_array) and distance_south > current_distance
              move_south(world_array)
              good_movement = true
            end
          end
          if used_movements.size == 4
            # ignore and don't move
            good_movement = true
          end
        end
      end
    else
      puts "no target"
      move_random
    end
  end

  # Move towards TARGET in the WORLD ARRAY based on euclidean distance.
  def move_towards(world_array, target)
    if target
      current_distance = Matrix.euclidean_distance(self, target)
      target_coords = [target.get_x_location, target.get_y_location]
      if can_move_east(world_array) and Matrix.coord_euclidean_distance([@x_location + 1, @y_location], target_coords) < current_distance
        move_east(world_array)
      elsif can_move_west(world_array) and Matrix.coord_euclidean_distance([@x_location - 1, @y_location], target_coords) < current_distance
        move_west(world_array)
      elsif can_move_north(world_array) and Matrix.coord_euclidean_distance([@x_location, @y_location - 1], target_coords) < current_distance
        move_north(world_array)
      elsif can_move_south(world_array) and Matrix.coord_euclidean_distance([@x_location, @y_location + 1], target_coords) < current_distance
        move_south(world_array)
      else
        # puts 'Cannot move closer to target'
      end
    else
      puts 'NO TARGET'
      move_random
    end
  end

  # Returns TRUE if a strawberry is present in the person's current square,
  # else FALSE.
  def strawberry_present(all_objects)
    all_strawberries = all_objects["Strawberries"]
    current_location = Matrix.two_to_one(@x_location, @y_location, @x_size)
    all_strawberries.each do |strawberry|
      if Matrix.two_to_one(strawberry.get_x_location, strawberry.get_y_location, @x_size) == current_location
        return true
      end
    end
    false
  end

  # Returns TRUE if a mushroom is present in the person's current square,
  # else FALSE.
  def mushroom_present(all_objects)
    all_mushrooms = all_objects["Mushrooms"]
    current_location = Matrix.two_to_one(@x_location, @y_location, @x_size)
    all_mushrooms.each do |mushroom|
      if Matrix.two_to_one(mushroom.get_x_location, mushroom.get_y_location, @x_size) == current_location
        return true
      end
    end
    false
  end

  # Returns the nearest strawberry in ALL_OBJECTS.
  def nearest_strawberry(all_objects)
    min_distance = @x_size * @y_size #Can never be larger than the size of the world
    nearest_strawberry = nil
    all_strawberries = all_objects["Strawberries"]
    all_strawberries.each do |strawberry|
      distance = Matrix.euclidean_distance(self, strawberry)
      if distance < min_distance
        nearest_strawberry = strawberry
        min_distance = distance
      end
    end
    nearest_strawberry
  end

  # Returns the nearest mushroom in ALL_OBJECTS.
  def nearest_mushroom(all_objects)
    min_distance = @x_size * @y_size #Can never be larger than the size of the world
    nearest_mushroom = nil
    all_mushrooms = all_objects["Mushrooms"]
    all_mushrooms.each do |mushroom|
      distance = Matrix.euclidean_distance(self, mushroom)
      if distance < min_distance
        nearest_mushroom = mushroom
        min_distance = distance
      end
    end
    nearest_mushroom
  end

  # Returns the nearest monster in ALL_OBJECTS.
  def nearest_monster(all_objects)
    min_distance = @x_size * @y_size #Can never be larger than the size of the world
    nearest_monster = nil
    all_monsters = all_objects["Monsters"]
    all_monsters.each do |monster|
      distance = Matrix.euclidean_distance(self, monster)
      if distance < min_distance
        nearest_monster = monster
        min_distance = distance
      end
    end
    nearest_monster
  end

  # Returns the nearest person in ALL_OBJECTS.
  def nearest_person(all_objects)
    min_distance = @x_size * @y_size #Can never be larger than the size of the world
    nearest_person = nil
    all_persons = all_objects["Persons"]
    all_persons.each do |person|
      if person != self
        distance = Matrix.euclidean_distance(self, person)
        if distance < min_distance
          nearest_person = person
          min_distance = distance
        end
      end
    end
    nearest_person
  end

  # Increase the energy level of a person when eating a strawberry.
  def eat
    @energy_level += 10
  end

  # Returns the @CHROMOSOME of the creature.
  def get_chromosome
    @chromosome
  end

  # Returns the @ENERGY_LEVEL` of the creature.
  def get_energy_level
    @energy_level
  end

  def reset_energy_level
    @energy_level = 25
  end

  # The string representation for the creature on the world array.
  def get_representation
    'P'
  end
end

class Monster < Creature
  def initialize(x, y, x_size, y_size)
    @x_location = x
    @y_location = y
    @x_size = x_size
    @y_size = y_size
    @total_length = x_size * y_size
    @type = 'Monster'
  end

  # Given WORLD_ARRAY and ALL_OBJECTS, move towards the closest person or, if
  # one doesn't exist, move randomly.
  def move(world_array, all_objects)
    target_person = nearest_person(all_objects)
    if target_person
      if target_person.get_x_location < @x_location
        if can_move_west(world_array)
          move_west(world_array)
        end
      elsif target_person.get_x_location > @x_location
        if can_move_east(world_array)
          move_east(world_array)
        end
      elsif target_person.get_y_location < @y_location
        if can_move_north(world_array)
          move_north(world_array)
        end
      elsif target_person.get_y_location > @y_location
        if can_move_south(world_array)
          move_south(world_array)
        end
      else
        puts 'PERSON ON MONSTER TILE'
      end
    else
      move_random(world_array)
    end
  end

  # The string representation for the creature on the world array.
  def get_representation
    'M'
  end

  # Returns the nearest person in ALL_OBJECTS.
  def nearest_person(all_objects)
    nearest_person = nil
    min_distance = @x_size * @y_size
    all_persons = all_objects["Persons"]
    all_persons.each do |person|
      distance = Matrix.euclidean_distance(self, person)
      if distance < min_distance
        nearest_person = person
        min_distance = distance
      end
    end
    nearest_person
  end
end

class Food
  def initialize(x_coord, y_coord)
    # The x coordinate of the food.
    @x_location = x_coord
    # The y coordinate of the food.
    @y_location = y_coord
    # The amount of food created.
    @amount = rand(1..2)
  end

  # Increase the amount of food.
  def increment
    @amount += 1
  end

  # Decrease the amount of food.
  def decrement
    @amount -= 1
  end

  # Return the amount of food present.
  def get_amount
    @amount
  end

  # Return the @X_LOCATION of the food.
  def get_x_location
    @x_location
  end

  # Return the @Y_LOCATION of the food.
  def get_y_location
    @y_location
  end
end

class Strawberry < Food
  # Return the string representation of the strawberry for world array.
  def get_representation
    "#{@amount}S"
  end
end

class Mushroom < Food
  # Return the string representation of the mushroom for world array.
  def get_representation
    "#{@amount}M"
  end
end
