class Creature
  def initialize(x, y)
    @x_location = x
    @y_location = y
    @energy_level = 10
  end

  def get_representation()
    "C"
  end

  def get_x_location()
    @x_location
  end

  def get_y_location()
    @y_location
  end

  def set_x_location(location)
    @x_location = location
  end

  def set_y_location(location)
    @y_location = location
  end

  def move_random()
    movement = rand(4)
    if movement == 0
      move_south()
    elsif movement == 1
      move_west()
    elsif movement == 2
      move_north()
    else
      move_east()
    end
  end

  def move_north()
    @y_location += 1
  end

  def move_south()
    @y_location -= 1
  end

  def move_east()
    @x_location += 1
  end

  def move_west()
    @x_location -= 1
  end

  def eat()
  end

  def strawberry_present
  end

  def nearest_strawberry
  end

end

class Monster
  def initialize(x, y)
    @x_location = rand(x)
    @y_location = rand(y)
  end

  def get_representation()
    "M"
  end

  def get_x_location()
    @x_location
  end

  def get_y_location()
    @y_location
  end

  def set_x_location(location)
    @x_location = location
  end

  def set_y_location(location)
    @y_location = location
  end
end
