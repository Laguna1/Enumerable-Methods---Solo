def my_each
  index = 0
    while index < length
      yield(self[index])
      index += 1
    end
end

def my_each_with_index
  index = 0
    while index < length
      yield([index], index)
      index += 1
    end
end

def my_select
    array = []
    my_each { |i| array << i if yield(i) }
    array  
end
