puts "Введите первую сторону треугольника:"
side1 = gets.chomp

puts "Введите вторую сторону треугольника:"
side2 = gets.chomp

puts "Введите третью сторону треугольника:"
side3 = gets.chomp

sides = [side1, side2, side3].collect { |el| el.to_i }
                             .sort { |a,b| b<=>a }


# прямоугольный?
def is_rectangular?(sides)
  sides[0]**2 == sides[1]**2 + sides[2]**2
end

# равносторонний?
def is_equilateral?(sides)
  sides.uniq.count == 1
end

# равнобедренный?
def is_isosceles?(sides)
  sides.uniq.count == 2
end

case true
when is_rectangular?(sides)
  puts "Треугольник прямоугольный."
when is_equilateral?(sides)
  puts "Треугольник равносторонний и равнобедренный."
when is_isosceles?(sides)
  puts "Треугольник равнобедренный."
else
  puts "Треугольник разносторонний"
end


