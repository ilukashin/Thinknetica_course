puts 'Введите основание треугольника:'
base = gets.chomp.to_i

puts 'Введите высоту треугольника:'
height = gets.chomp.to_i

area = 0.5 * base * height

puts '***'*10, 'Результат:', "Площаль треугольника = #{area}"
