def my_each
  for element in self
  yield(element)
    end
end

def my_each_with_index
    index = 0
    for element in self
        yield(element, index)
        index += 1
    end
end
