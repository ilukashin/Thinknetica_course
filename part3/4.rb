VOWELS = %{ а у о ы и э я ю ё е }

hash = ('а'..'я').to_a.each.with_index(1).each_with_object({}) do |(value, index), result_hash|
  result_hash[value] = index if VOWELS.include?(value) 
end

p hash
