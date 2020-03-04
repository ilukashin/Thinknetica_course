hash = ('а'..'я').to_a.each_with_index.each_with_object({}) do |(value, index), result_hash|
  result_hash[value] = index + 1 if %{ а у о ы и э я ю ё е }.include?(value) 
end

p hash