arr = (10..100).to_a.each_with_object([]) { |value, result| result << value if value % 5 == 0 }

p arr