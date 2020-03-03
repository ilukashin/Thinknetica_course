puts 'Введите основание треугольника:'
base = gets.chomp.to_i

puts 'Введите высоту треугольника:'
height = gets.chomp.to_i

area = 1 / 2.0 * base * height

puts '***'*10, 'Результат:', "Площаль треугольника = #{area}"

