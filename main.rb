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
