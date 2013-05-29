require File.expand_path('../stores', __FILE__)

module RRList

  # Represents a Round Robin List.
  # You set the max number of items and the size does not increse. While you add more items you lose the older items
  class List

    def initialize(options={},&before_add)
      raise ":size is required" unless options[:size]

      @values = options[:store] || RRList::Store::InMemoryArray.new
      @size = options[:size]
      @position = 0
      @range = options[:range] || 1
      @current_index = options[:overal_position] || 0

      if options[:values]
        @original_values = options[:values]
        @values.set_values(options[:values])
      else
        @values.fill(nil,0...@size)
      end

      @before_add_proc = before_add if block_given?
    end

    def clear
       @values.fill(nil,0...@size)
    end

    def reset
      @values.set_values(options[:values])
      @position = 0
      @current_index = 0
    end

    #@return The `min_index` and `max_index` as a list
    def ranges
      return [min_index,max_index]
    end

    #@return True if the given number is in the limits of the current max an min index of the list
    def in_limits?(index)
      ( !higher?(index) && !lower?(index))
    end

    #@return True if the given number is out of the range and all numbers will be lost if set
    def out_of_range?(index) # refactor to out of limits?
      if in_limits?(index)
        return false
      elsif higher?(index)
        (index - max_index) >= (@size*@range)
      elsif lower?(index)
        (min_index - index) >= (@size*@range)
      end
    end

    #@retrun True if the giving number is higher that the current max index.
    def higher?(index)
      index > (max_index + remaining_in_slot)
    end

    #@retrun True if the giving number is lower that the current min index.
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

    #@return the value for the specified index
    def get(index)
      pos = ((index/@range) % @size)
      @values.get(pos)
    end

    # Adds a value to the next index position
    def add(value)
      @add_at_next = 0 unless @add_at_next
      add_at @add_at_next, value
    end

    # Add an item to the specified postion and set the cursor to that position
    def add_at(index,value)
      raise "Index is lower that current index" if index < max_index

      @add_at_next = index + 1
      pos = ((index/@range) % @size)

      if out_of_range?(index)
        @values.fill_with_nils
      elsif higher?(index)
        (pos-1).downto(@position) { |i| @values.put(i,nil) } if @current_index >= @size
        @values.put(pos,nil) # We clean the value, if not it gets used by @before_add
      end

      set_value(pos,value)
      @position = pos + 1
      @current_index = index
      self
    end

    #@return if range is used, returns the remaining numbers in the current position.
    def remaining_in_slot
      (@range - (max_index % @range)) - 1
    end

    #@return the index size.
    def index_size
      @size*@range
    end

    #@return The min index of this list
    def min_index
      if max_index <= index_size
        0
      else
        (max_index + 1) - index_size + remaining_in_slot
      end
    end

    #@return the max indes of current position
    def max_index
      @current_index
    end

    #@return the values
    def values
      if @current_index < (@size*@range)
        @values.raw
      else
        @values.start_at(@position)
      end
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
      if @before_add_proc
        adding = @before_add_proc.call(index,@values.get(index),val)
        @values.put(index, adding)
      else
        @values.put(index,val)
      end
    end

  end
end