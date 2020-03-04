require_relative './1.rb'

puts "Введите дату:"
date = gets.chomp.to_i

puts "Введите месяц:"
month = gets.chomp.to_i

puts "Введите год:"
year = gets.chomp.to_i

def is_leap(year)
  year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
end

MONTHS['Февраль'] = 29 if is_leap(year)

result = date
MONTHS.values.each_with_index do |days, i|
  break if i + 1 == month
  result += days
end

puts result