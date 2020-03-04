basket = {}

while true

  puts  'Введите название товара:'
  name = gets.chomp.strip

  break if name.downcase == 'стоп'

  puts 'Введите цену единицы товара:'
  price = gets.chomp.to_f

  puts 'Введите количество:'
  count = gets.chomp.to_i

  basket[name] = { price => count }
end

puts "\nВаша корзина:"
pp basket

puts "\nОбщая стоимость каждого наименования:"
intermediate_price = basket.each_with_object({}) do |(name, details), position_summ|
  summ = details.keys.first * details.values.first
  puts "#{name}: #{summ}"
  position_summ[name] = summ
end

puts "\nИтого к оплате:"
puts intermediate_price.values.inject(0.0) { |summ, price| summ += price }