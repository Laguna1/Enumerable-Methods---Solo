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
  arr = []
    self.my_each { |i|
    if yield(i)
    arr.push(i) 
    end
      }
    arr   
end
