puts "Введите a:"
a = gets.chomp.to_i

puts "Введите b:"
b = gets.chomp.to_i

puts "Введите c:"
c = gets.chomp.to_i


D = b**2 - 4*a*c

if D < 0
  puts "Корней нет"
else
  x1 = (-b + Math.sqrt(D)) / 2*a
  x2 = (-b - Math.sqrt(D)) / 2*a
  puts "Дискриминант D = #{D}, корни уравнения: #{[x1,x2].uniq}"
end

