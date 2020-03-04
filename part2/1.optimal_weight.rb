puts 'Введите ваше имя:'
user_name = gets.chomp

puts 'Введите ваш рост:'
user_height = gets.chomp

puts 'Введите ваш текущий вес:'
user_weight = gets.chomp

optimal_weight = (user_height.to_i - 110) * 1.15

weight_difference = user_weight.to_f - optimal_weight

puts '***'*10, 'Результат:'

if weight_difference <= 0
  puts 'Ваш вес уже оптимальный'
else
  puts "#{user_name}, превышение массы тела на #{weight_difference.round(1)}"
end

