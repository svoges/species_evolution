class Creature
  def initialize(x, y, x_size, y_size)
    @x_location = x
    @y_location = y
    @x_size = x_size
    @y_size = y_size
    @total_length = x_size * y_size
    @type = 'Creature'
  end

  def get_single_coord
    Matrix.two_to_one(@x_location, @y_location, @x_size)
  end

  def get_x_location
    @x_location
  end

  def get_y_location
    @y_location
  end

  def set_x_location(location)
    @x_location = location
  end

  def set_y_location(location)
    @y_location = location
  end

  def movements
    puts "North #{can_move_north}"
    puts "South #{can_move_south}"
    puts "East #{can_move_east}"
    puts "West #{can_move_west}"
  end

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

  def objects_north(world_array)
    coordinate = Matrix.two_to_one(@x_location, @y_location - 1, @x_size)
    return world_array[coordinate]
  end

  def objects_west(world_array)
    coordinate = Matrix.two_to_one(@x_location - 1, @y_location, @x_size)
    return world_array[coordinate]
  end

  def objects_east(world_array)
    coordinate = Matrix.two_to_one(@x_location + 1, @y_location, @x_size)
    return world_array[coordinate]
  end

  def objects_south(world_array)
    coordinate = Matrix.two_to_one(@x_location, @y_location + 1, @x_size)
    return world_array[coordinate]
  end

  def move_north(world_array)
    if can_move_north(world_array)
      @y_location -= 1
    else
      puts "ERROR: #{@type} illegally moved north"
      exit
    end
  end

  def move_south(world_array)
    if can_move_south(world_array)
      @y_location += 1
    else
      puts "ERROR: #{@type} illegally moved south"
      exit
    end
  end

  def move_east(world_array)
    if can_move_east(world_array)
      @x_location += 1
    else
      puts "ERROR: #{@type} illegally moved east"
      exit
    end
  end

  def move_west(world_array)
    if can_move_west(world_array)
      @x_location -= 1
    else
      puts "ERROR: #{@type} illegally moved west"
      exit
    end
  end

  def no_possible_moves(world_array)
    !(can_move_west(world_array) or can_move_east(world_array) or can_move_north(world_array) or can_move_south(world_array))
  end

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
        puts "NO POSSIBLE MOVES"
        # do nothing
      else
        good_movement = false
      end
    end
  end
end

class Chromosome
  def initialize
    @sequence = {
      1 => [eat_or_ignore, rand(100)],
      2 => [eat_or_ignore, rand(100)],
      3 => [movement,      rand(100)],
      4 => [movement,      rand(100)],
      5 => [movement,      rand(100)],
      6 => [movement,      rand(100)]
    }
  end

  def get_sequence
    @sequence
  end

  def get_strawb_present_weight
    @sequence[1][1]
  end

  def get_mush_present_weight
    @sequence[2][1]
  end

  def get_nearest_strawb_weight
    @sequence[3][1]
  end

  def get_nearest_mush_weight
    @sequence[4][1]
  end

  def get_nearest_monster_weight
    @sequence[5][1]
  end

  def get_nearest_person_weight
    @sequence[6][1]
  end

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
end

class Person < Creature
  def initialize(x, y, x_size, y_size)
    @x_location = x
    @y_location = y
    @x_size = x_size
    @y_size = y_size
    @total_length = x_size * y_size
    @type = 'Person'
    @energy_level = 10
    @chromosome = Chromosome.new
  end

  def get_chromosome
    @chromosome
  end

  def get_energy_level
    @energy_level
  end

  def get_representation
    'P'
  end

  def eat
    @energy_level += 2
  end

  # See the monster example for nearest person as a template
  def move_towards(world_array, target)
    if target
      current_distance = Matrix.euclidean_distance(self, target)
      target_coords = [target.get_x_location, target.get_y_location]
      if can_move_east(world_array) and Matrix.coord_euclidean_distance([@x_location + 1, @y_location], target_coords) <= current_distance
        move_east(world_array)
      elsif can_move_west(world_array) and Matrix.coord_euclidean_distance([@x_location - 1, @y_location], target_coords) <= current_distance
        move_west(world_array)
      elsif can_move_north(world_array) and Matrix.coord_euclidean_distance([@x_location, @y_location - 1], target_coords) <= current_distance
        move_north(world_array)
      elsif can_move_south(world_array) and Matrix.coord_euclidean_distance([@x_location, @y_location + 1], target_coords) <= current_distance
        move_south(world_array)
      else
        puts 'Towards: TARGET ON SAME TILE'
      end
    else
      puts 'NO TARGET'
      move_random
    end
  end

  # increase the euclidean distance
  def away_from(world_array, target)
    if target
      current_distance = Matrix.euclidean_distance(self, target)
      target_coords = [target.get_x_location, target.get_y_location]
      if can_move_east(world_array) and Matrix.coord_euclidean_distance([@x_location + 1, @y_location], target_coords) > current_distance
        move_east(world_array)
      elsif can_move_west(world_array) and Matrix.coord_euclidean_distance([@x_location - 1, @y_location], target_coords) > current_distance
        move_west(world_array)
      elsif can_move_north(world_array) and Matrix.coord_euclidean_distance([@x_location, @y_location - 1], target_coords) > current_distance
        move_north(world_array)
      elsif can_move_south(world_array) and Matrix.coord_euclidean_distance([@x_location, @y_location + 1], target_coords) > current_distance
        move_south(world_array)
      else
        puts 'Cannot move further away from target'
      end
    else
      puts 'NO TARGET'
      move_random
    end
  end

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

  # Main function for executing a person's action
  def move(world_array, all_objects)
    # Find the most weighted applicable position in the chromosome
    role = best_role(all_objects)
    # Get the action corresponding to this position
    action = get_action(role)
    @energy_level -= 1
    action
  end

  def get_action(role)
    if role
      action = @chromosome.get_sequence[role][0]
    else
      action = 'random'
    end
    # ex: [3, 'towards']
    [role, action]
  end

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

    if !all_objects["Persons"].reject! { |elem| elem != self }.nil?
      if Matrix.euclidean_distance(self, nearest_person(all_objects)) < 3
        new_weight = @chromosome.get_nearest_person_weight
        if new_weight > max_weight
          max_weight = new_weight
          role = 6
        end
      end
    end
    role
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

  def get_representation
    'M'
  end

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
    if nearest_person.nil?
      puts 'NO MORE PEOPLE'
    end
    nearest_person
  end

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
end

class Food
  def initialize(x, y)
    @x_location = x
    @y_location = y
    @amount = rand(1..4)
  end

  def get_amount
    @amount
  end

  def get_x_location
    @x_location
  end

  def get_y_location
    @y_location
  end

  def increment
    @amount += 1
  end

  def decrement
    @amount -= 1
  end
end

class Strawberry < Food
  def get_representation
    "#{@amount}S"
  end
end

class Mushroom < Food
  def get_representation
    "#{@amount}M"
  end
end
