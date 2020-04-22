def my_each
  return to_enum unless block_given?

    index = 0
    while index < length
        yield(self[index])
        index += 1
      end
end

def my_each_with_index
  return to_enum unless block_given?

    index = 0
    while index < length
        yield([index], index)
        index += 1
      end
end

def my_select
  return to_enum unless block_given?

    array = []
    my_each { |i| array.push(i) if yield(i) }
    array
end
