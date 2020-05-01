def my_each
  return to_enum unless block_given?

  index = 0
  while index < length
    yield(self[index])
    index += 1
  end
  self
end

def my_each_with_index
  return to_enum unless block_given?

  index = 0
  while index < length
    yield(self[index], index)
    index += 1
  end
  self
end

def my_select
  return to_enum unless block_given?

  array = []
  my_each { |i| array.push(i) if yield(i) }
  array
end

def my_all?(param = nil)
  unless block_given?
    if param == nil?
      my_each { |i| return false unless param == i }
    else
      my_each { |i| return false unless i }
    end
    return true
  end
  my_each { |x| return false unless yield(x) }
  true
end

def my_any?(param = nil)
  unless block_given?
    if param == nil?
      my_each { |i| return true unless param == i }
    else
      my_each { |i| return true unless i }
    end
    return false
  end
  my_each { |x| return true unless yield(x) }
  false
end

# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
def my_none?(param = true)
  if block_given?
    each { |item| return false if yield(item) }
  elsif param.is_a? Regexp
    each { |item| return false if param.match(item) }
  elsif param.is_a? Class
    each { |item| return false if item.instance_of? param }
  else
    each { |item| return false if item == param }
  end
  true
end

def my_map(proc = nil)
  return to_enum(:my_map) unless block_given?

  array = []
  proc ? my_each { |x| array << proc.call(x) } : my_each { |x| array << yield(x) }
  array
end

def my_inject(*given)
  arr = to_a.dup
  if given[0].nil?
    injected = arr.shift
  elsif given[1].nil? && !block_given?
    sym = given[0]
    injected = arr.shift
  elsif given[1].nil? && block_given?
    injected = given[0]
  else
    injected = given[0]
    sym = given[1]
  end
  arr[0..-1].my_each do |item|
    injected = if sym
                 injected.send(sym, item)
               else
                 yield(injected, item)
               end
  end
  injected
end

# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def multiply_els(arr)
  arr.my_inject { |a, b| a * b }
end

puts multiply_els([2, 4, 5])

a = [16, 8, 3, 6]
my_proc = proc { |num| num + 7 }
puts a.my_map(my_proc) { |num| num + 7 }

puts "only proc: #{[16, 8, 3, 6].my_map(&my_proc)}\n"
puts "ignore block and use proc: #{[16, 8, 3, 6].my_map(my_proc) { |num| num + 7 }}\n"
puts "only block: #{[16, 8, 3, 6].my_map { |num| num + 7 }}\n"