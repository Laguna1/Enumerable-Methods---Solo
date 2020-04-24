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

def my_none?(param = nil)
  return my_none?(param) if block_given? && !param.nil?

  if block_given?
    to_a.my_each { |item| return false if yield(item) }
  elsif param.is_a? Regexp
    to_a.my_each { |item| return false if item.to_s.match(param) }
  elsif param.is_a? Class
    to_a.my_each { |item| return false if item.is_a? param }
  elsif param.nil?
    to_a.my_each { |item| return false if item }
  end
  true
end