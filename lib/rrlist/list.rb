require File.expand_path('../stores', __FILE__)

module RRList

  # @author Federico Dayan
  # Represents a Round Robin List.
  # You set the max number of items and the size does not increse. While you add more items you lose the older items
  class List

    # Creates an object
    # @param options [Hash]
    # @option options [Integer] :size The size of the list. It does not add more elements than this.
    # @option options [Integer] :range The range of the list. A range of 5 group 5 indexes into one position.
    # @option options [Integer] :store Represents the where we save the data. It must follow a contract (see RRList:Stores:InMemoryArray)
    # @yield [index, old_value, new_value]
    def initialize(options={},&function_proc)
      raise ":size is required" unless options[:size]
      raise ":range should be greater thant 0" if options[:range] &&  options[:range] < 1

      @store = options[:store] || RRList::Stores::InMemoryArray.new
      @size = options[:size].to_i
      @range = options[:range] || 1

      reset

      @function_proc = function_proc if block_given?
    end

    # Sets all values to nil, but it does not move the cursor
    def clear
       @store.fill(nil,0...@size)
    end

    # Reset this list, set all values to nil and move cursor to position 0
    def reset
      clear
      @position = 0
      @current_index = 0
    end

    # @return [Array<Integer>] The min_index and max_index as a list
    def ranges
      return [min_index,max_index]
    end

    # @param index [Integer] A number
    # @return [True] if the given number is in the limits of the current max an min index of the list
    def in_limits?(index)
      ( !higher?(index) && !lower?(index))
    end

    # @param index [Integer] A number
    # @return [True] if the given number is out of the range and all numbers will be lost if set
    def out_of_range?(index) # refactor to out of limits?
      if in_limits?(index)
        return false
      elsif higher?(index)
        (index - max_index) >= (@size*@range)
      elsif lower?(index)
        (min_index - index) >= (@size*@range)
      end
    end

    # @param index [Integer] A number
    # @return [True] if the giving number is higher that the current max index.
    def higher?(index)
      index > (max_index + remaining_in_slot)
    end

    # @param index [Integer] A number
    # @return [True] if the giving number is lower that the current min index.
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

    # @return [Object] the value for the specified index
    def get(index)
      return nil unless in_limits?(index)
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
      pos = position_for_index(index)

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

    # Set the specified value in the given index. The index must be in the range.
    def set_at(index, value)
      raise "The index #{index} is not in the range of the list" unless in_limits?(index)

      pos = position_for_index(index)

      set_value(pos,value)
    end

    # @return [Integer] if range is used, returns the remaining numbers in the current position.
    def remaining_in_slot
      (@range - (max_index % @range)) - 1
    end

    # @return [Integer] the index size of this list
    def index_size
      @size*@range
    end

    # @return [Integer] The min index of the current list
    def min_index
      if max_index <= index_size
        0
      else
        (max_index + 1) - index_size + remaining_in_slot
      end
    end

    # @return [Integer] the max indes of current list
    def max_index
      @current_index
    end

    # @return [Array<Object>] The values of this list
    def values
      ret = if @current_index < (@size*@range)
              @store.raw
            else
              @store.start_at(@position)
            end

      return ret
    end

    # Pretty print this object
    def to_s
      values.to_s
    end

    #########################
    #   Array API
    #########################

    # Returns the value for the given index
    # @see #get
    def [](index)
      get(index)
    end

    # Sets a value to in the given index.
    # @see #add_at
    def []=(index,value)
      add_at(index,value)
    end

    # Adds a value to the end of the list.
    # @see #add
    def << value
      add(value)
    end

   private

    def position_for_index(index)
      ((index/@range) % @size)
    end

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