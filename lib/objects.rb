class Creature
  def initialize(x, y, x_size, y_size)
    @x_location = x
    @y_location = y
    @x_size = x_size
    @y_size = y_size
    @total_length = x_size * y_size
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
    puts "Wast #{can_move_west}"
  end

  def can_move_north
    if get_single_coord < @x_size
      return false
    else
      return true
    end
  end

  def can_move_west
    if get_single_coord % @x_size == 0
      return false
    else
      return true
    end
  end

  def can_move_south
    if @total_length - get_single_coord <= @x_size
      return false
    else
      return true
    end
  end

  def can_move_east
    if get_single_coord % @x_size == @x_size - 1
      return false
    else
      return true
    end
  end

  def move_north
    if can_move_north
      @y_location -= 1
    else
      puts 'ERROR: Person illegally moved north'
      exit
    end
  end

  def move_south
    if can_move_south
      @y_location += 1
    else
      puts 'ERROR: Person illegally moved south'
      exit
    end
  end

  def move_east
    if can_move_east
      @x_location += 1
    else
      puts 'ERROR: Person illegally moved east'
      exit
    end
  end

  def move_west
    if can_move_west
      @x_location -= 1
    else
      puts 'ERROR: Person illegally moved west'
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
    @energy_level = 10
  end

  def get_representation
    'P'
  end

  def move_random
    good_movement = false
    while !good_movement
      movement = rand(4)
      good_movement = true
      if movement == 0 and can_move_south
        puts "SOUTH"
        move_south()
      elsif movement == 1 and can_move_west
        puts "WEST"
        move_west()
      elsif movement == 2 and can_move_north
        puts "NORTH"
        move_north()
      elsif movement == 3 and can_move_east
        puts "EAST"
        move_east()
      else
        good_movement = false
      end
    end
  end

  def eat()
  end

  def strawberry_present
  end

  def nearest_strawberry
  end
end

class Monster < Creature
  def initialize(x, y, x_size, y_size)
    @x_location = x
    @y_location = y
  end

  def get_representation
    'M'
  end
end

class Food
  def initialize(x, y)
    @x_location = x
    @y_location = y
    @amount = 1
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
