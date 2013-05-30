require File.expand_path('../stores', __FILE__)

module RRList

  # Represents a Round Robin List.
  # You set the max number of items and the size does not increse. While you add more items you lose the older items
  class List

    def initialize(options={},&function_proc)
      raise ":size is required" unless options[:size]
      raise ":range should be greater thant 0" if options[:range] &&  options[:range] < 1

      @store = options[:store] || RRList::Stores::InMemoryArray.new
      @size = options[:size]
      @range = options[:range] || 1

      reset

      @function_proc = function_proc if block_given?
    end

    # Sets all values to nil, but it does not the cursor
    def clear
       @store.fill(nil,0...@size)
    end

    def reset
      clear
      @position = 0
      @current_index = 0
    end

    # @return The `min_index` and `max_index` as a list
    def ranges
      return [min_index,max_index]
    end

    # @return True if the given number is in the limits of the current max an min index of the list
    def in_limits?(index)
      ( !higher?(index) && !lower?(index))
    end

    # @return True if the given number is out of the range and all numbers will be lost if set
    def out_of_range?(index) # refactor to out of limits?
      if in_limits?(index)
        return false
      elsif higher?(index)
        (index - max_index) >= (@size*@range)
      elsif lower?(index)
        (min_index - index) >= (@size*@range)
      end
    end

    # @retrun True if the giving number is higher that the current max index.
    def higher?(index)
      index > (max_index + remaining_in_slot)
    end

    # @retrun True if the giving number is lower that the current min index.
    def lower?(index)
      index < min_index
    end

    # Iterates of over the values. Expects a block and passes the value
    def each(&blk)
      values.each(&blk)
    end

    # Iterates of over the values. Expects a block and passes the value and index
    def each_with_index
      ordered_values = values
      ordered_values.each_with_index do |v,i|
        yield ordered_values[i], min_index + (i*@range)
      end
    end

    # @return the value for the specified index
    def get(index)
      pos = ((index/@range) % @size)
      @store.get(pos)
    end

    # Adds a value to the next index position and moves the cursor forward
    # @param value any object
    def add(value)
      @add_at_next = 0 unless @add_at_next
      add_at @add_at_next, value
    end

    # Add an item to the specified postion and set the cursor to that position
    # @param index must be higher than max_index
    # @param value any object
    def add_at(index,value)
      raise "Index is lower that current index" if index < max_index

      @add_at_next = index + 1
      pos = ((index/@range) % @size)

      if out_of_range?(index)
        @store.fill_with_nils
      elsif higher?(index)
        (pos-1).downto(@position) { |i| @store.put(i,nil) } if @current_index >= @size
        @store.put(pos,nil) # We clean the value, if not it gets used by @before_add
      end

      set_value(pos,value)
      @position = pos + 1
      @current_index = index
      self
    end

    # @return if range is used, returns the remaining numbers in the current position.
    def remaining_in_slot
      (@range - (max_index % @range)) - 1
    end

    # @return the index size.
    def index_size
      @size*@range
    end

    # @return The min index of this list
    def min_index
      if max_index <= index_size
        0
      else
        (max_index + 1) - index_size + remaining_in_slot
      end
    end

    # @return the max indes of current position
    def max_index
      @current_index
    end

    # @return the values
    def values
      ret = if @current_index < (@size*@range)
              @store.raw
            else
              @store.start_at(@position)
            end

      return ret
    end

    def to_s
      values.to_s
    end

    #########################
    #   Array API
    #########################

    def [](index)
      get(index)
    end

    def []=(index,value)
      add_at(index,value)
    end

    def << value
      add(value)
    end

   private

    def set_value(index,val,update_position=true)
      if @function_proc
        adding = @function_proc.call(index,@store.get(index),val)
        @store.put(index, adding)
      else
        @store.put(index,val)
      end
    end

  end
end