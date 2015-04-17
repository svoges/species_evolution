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
        puts "SOUTH"
        move_south(world_array)
      elsif movement == 1 and can_move_west(world_array)
        puts "WEST"
        move_west(world_array)
      elsif movement == 2 and can_move_north(world_array)
        puts "NORTH"
        move_north(world_array)
      elsif movement == 3 and can_move_east(world_array)
        puts "EAST"
        move_east(world_array)
      elsif no_possible_moves(world_array)
        # do nothing
      else
        good_movement = false
      end
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
  end

  def get_representation
    'P'
  end

  def eat()
    @energy_level += 2
  end

  def move_random(world_array)
    good_movement = false
    while !good_movement
      movement = rand(4)
      good_movement = true
      if movement == 0 and can_move_south(world_array)
        puts "SOUTH"
        move_south(world_array)
      elsif movement == 1 and can_move_west(world_array)
        puts "WEST"
        move_west(world_array)
      elsif movement == 2 and can_move_north(world_array)
        puts "NORTH"
        move_north(world_array)
      elsif movement == 3 and can_move_east(world_array)
        puts "EAST"
        move_east(world_array)
      elsif no_possible_moves(world_array)
        puts "NO POSSIBLE MOVES"
        # do nothing
      else
        good_movement = false
      end
    end
    @energy_level -= 1
  end

  def nearest_strawberry
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
