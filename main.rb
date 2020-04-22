def my_each
    index = 0
    while index < self.length
      yield(self[index])   
        index+=1   
    end 
end

def my_each_with_index
  index = 0
    while index < self.length
      yield([index], index)
        index += 1
    end
end
