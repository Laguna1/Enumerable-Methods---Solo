# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
module Enumerable
  def my_each
    return to_enum unless block_given?
    index = 0
    while index < length
      yield(self[index])
      index += 1
    end
   # self
  end

  def my_each_with_index
    return to_enum unless block_given?
    index = 0
    while index < length
      yield(self[index], index)
      index += 1
    end
    #self
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

  def my_count(arg = nil)
    count = 0
    my_each do |value|
      block_given? ? (count += 1 if yield value) : (count += 1 if value == arg || arg.nil?)
    end
    count
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given?
    array = []
    proc ? my_each { |x| array << proc.call(x) } : my_each { |x| array << yield(x) }
    array
  end

  def my_inject(*given)
     array = to_a.dup
    if given[0].nil?
     injected = array.shift
    elsif given[1].nil? && !block_given?
      sym = given[0]
      injected = array.shift
    elsif given[1].nil? && block_given?
      injected = given[0]
    else
      injected = given[0]
      sym = given[1]
    end
    array[0..size].my_each do |item|
      injected = if sym
          injected.send(sym, item)
        else
             yield(injected, item)

        end
     end
     injected
  end
  
end

  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def multiply_els(arr)
    arr.my_inject { |a, b| a * b }
  end



puts "my_each"
  puts "-------"
  puts [1, 2, 3].my_each { |x| print "#{ x + 7 }" } # => 8 9 10
  puts

puts "my_each_with_index"
  puts "-------"
  print [1, 2, 3].my_each_with_index { |item, index| puts "#{item} : #{index}  " } # => 1 : 0, 2 : 1, 3 : 2
  puts

puts "my_select" 
  puts "---------"
  puts [1,2,3,4,5,6].my_select { |i| i.even? } # => [2, 4, 6]
  puts
  puts [0, -15, 101, 6,-7].my_select { |i| i >= 0 } # => [0, 101, 6]
  puts [1,2,3,4,5,6].my_select(&:odd?) # => [1, 3, 5]
  puts

puts "my_all?"
  puts "-------"
  puts [1, 3, 5, 7].my_all? { |i| i.odd? } # => true
  puts [-7, -5, -3, -1].my_all? { |i| i < 0 } # => true
  puts [1, 2, 3, 4].my_all? { |i| i.odd? } # => false
  puts [-7, -5, -3, -1].my_all? { |i| i > 0 } # => false

puts "my_any?"
  puts "-------"
  puts [1, 2, 3, 5].my_any? { |i| i.even? } # => true
  puts [1, 3, 5, 7].my_any? { |i| i.odd? } # => true
  puts [2, 4, 6, 8].my_any? { |i| i.odd? } # => false
  puts [1, nil, false].my_any?(Integer) # => true
  puts [1, nil, false].my_any?(1) # => true
  puts ['dog', 'door', 'rod', 'blade'].my_any?(/z/) # => false
  puts [1, 2 ,3].my_any?("1") # => true
  puts

puts "my_none?"
  puts "--------"
  puts [3, 5, 7, 11].my_none? { |n| n.even? } # => true
  puts ["sushi", "pizza", "burrito"].my_none? { |word| word[0] == "a" } # => true
  puts [3, 5, 4, 7, 11].my_none? { |n| n.even? } # => false
  puts ["asparagus", "sushi", "pizza", "apple", "burrito"].my_none? { |word| word[0] == "a" } # => false
  puts [nil, false, nil, false].my_none? # => true
  puts [1, 2 ,3].my_none? # => true
  puts [1, 2 ,3].my_none?(String) # => true
  puts [1,2,3,4,5].my_none?(2) # => false
  puts [1, 2, 3].my_none?(4) # => true
  
  
puts "my_count"
  puts "--------"
  puts [1,4,3,8].my_count { |i| i.even? } # => 2
  puts ["PIZZA", "SANDWICH", "BURGER"].my_count { |s| s == s.upcase } # => 3
  puts ["pizza", "sandwich", "burger", "nuggets"].my_count { |s| s == s.upcase } # => 0
  puts [1,2,3,4].my_count # => 4
  p [1,1,1,1,2,3].my_count(1) # => 4
  puts

puts "my_map"
  puts "------"
  p [1,2,3].my_map { |x| 2 * x } # => [2,4,6]
  p ["Hello", "World"].my_map { |word| word + "?" } # => ["Hello?", "World?"]
  p [false, true].my_map { |bool| !bool } # => [true, false]
   my_proc = Proc.new {|num| num > 10 }
  puts [1, 8, 2, 99].my_map(my_proc) {|num| num < 10 } # => false false false true
  puts

 puts "my_inject"
  puts "---------"
  p [1,2,3,4].my_inject(10) { |sym, item| sym + item} # => 20
  p [5, 1, 2].my_inject("+") # => 8
  p (5..10).my_inject(2, :*) # => 302400
  p (5..10).my_inject(4) {|prod, n| prod * n} # => 604800
  puts
 
puts "multiply_els "
 puts "---------"
  puts multiply_els([2, 4, 5]) # => 40