module Matrix
  # Draw a sample line in the matrix
  # def Matrix.draw_sample_line(length)
  #   (0..length).each do
  #     print " + "
  #   end
  #   puts "\n"
  # end
  #
  # Display the matrix in ASCII format based on length and width
  # def Matrix.draw_sample_matrix(x_size, y_size)
  #   (0..y_size).each do
  #     draw_sample_line(x_size)
  #   end
  # end

  # Returns the best object to show in the array of the matrix location
  def Matrix.best_object_to_show(object_array)
    best_object = nil
    object_array.each do |object|
      if object.class == Person or object.class == Monster
        best_object = object
      elsif best_object == nil
        best_object = object
      end
    end
    best_object
  end

  # Draw a line based on a given matrix
  def Matrix.draw_line(array)
    array.each do |elem|
      if !elem.empty?
        object = best_object_to_show(elem)
        repr = object.get_representation
        if repr.length == 1
          print " #{repr} "
        elsif repr.length == 2
          print " #{repr}"
        else
          print "#{repr}"
        end
      else
        print ' - '
      end
      print ' '
    end
    puts "\n"
  end

  # Draw a 1-D matrix in 2-D
  def Matrix.draw_matrix(array, x_size, y_size)
    print '    '
    (0..x_size-1).each { |i| print " #{ i }  "}
    print "\n    "
    (0..x_size-1).each { |i| print ' *  '}
    puts ''
    counter = 0
    copied_array = Array.new(array)
    (0..y_size - 1).each do |i|
      print "#{counter} * "
      to_print = copied_array.take(x_size)
      draw_line(to_print)
      copied_array.shift(x_size)
      counter += 1
    end
    if !copied_array.empty?
      puts 'ERROR: Entire matrix was not drawn'
    end
    puts ''
  end

  def Matrix.two_to_one(x_coord, y_coord, x_size)
    x_size * y_coord + x_coord
  end

  # Finds distance from obj1 to obj2
  def Matrix.euclidean_distance(obj1, obj2)
    Math.sqrt((obj1.get_x_location - obj2.get_x_location) ** 2 + (obj1.get_y_location - obj2.get_y_location) ** 2)
  end

  # Finds distance, but obj1 = [x1, y1] and obj2 = [x2, y2]
  def Matrix.coord_euclidean_distance(obj1, obj2)
    Math.sqrt((obj1[0] - obj2[0]) ** 2 + (obj1[1] - obj2[1]) ** 2)
  end
end
