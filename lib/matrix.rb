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

  # Draw a line based on a given matrix
  def Matrix.draw_line(array)
    array.each do |elem|
      if [Monster, Creature, Strawberry, Mushroom].include?(elem.class)
        repr = elem.get_representation
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
    (0..x_size-1).each { |i| print ' -  '}
    puts ''
    counter = 0
    copied_array = Array.new(array)
    (0..y_size - 1).each do |i|
      print "#{counter} | "
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
end
