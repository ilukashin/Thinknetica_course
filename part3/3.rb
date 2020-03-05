fib_arr = []

if fib_arr.empty?
  fib_arr = [0, 1, 1]
end

loop do
  next_int = fib_arr.last + fib_arr[-2]
  break if next_int > 100
  fib_arr << next_int
end

p fib_arr
