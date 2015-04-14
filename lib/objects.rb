class Creature
  def initialize(x, y)
    @x_location = rand(x)
    @y_location = rand(y)
  end

  def get_x_location()
    @x_location
  end

  def get_y_location()
    @y_location
  end
end

class Monster
end
