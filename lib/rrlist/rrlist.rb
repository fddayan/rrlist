require File.expand_path('../rrmath', __FILE__)

class RRList

  attr_reader :overal_position,:size,:position,:range

  def initialize(options)
    raise ":size is required" unless options[:size]

    @values = options[:store] || RRListStore::InMemoryArray.new
    @size = options[:size]
    @position = options[:position] || 0
    @range = options[:range] || 1
    @overal_position = options[:overal_position] || 0

    if options[:values]
      @values.set_values(options[:values])
    else
      @values.fill(nil,0...@size)
    end

    @before_add_name = options[:before_add]

    befor_add_proc = case options[:before_add]
                      when Symbol
                        RRMath.get_function_prod(options[:before_add])
                      else
                        options[:before_add]
                    end

    before_add(&befor_add_proc)
  end

  # def init(values)
    # @values.set_values(values)
  # end
  
  def << v
    # raise
    self.add(v)
  end

  def ranges
    return [min_index,max_index]
  end

  def in_limits?(num)
    ( !higher?(num) && !lower?(num))
  end

  def out_of_range?(index)
    if in_limits?(index)
      return false
    elsif higher?(index)
      (index - max_index) >= (@size*@range)
    elsif lower?(index)
      (min_index - index) >= (@size*@range)
    end
  end

  def higher?(index)
    index > (max_index + remaining_in_slot)
  end

  def lower?(index)
    index < min_index
  end


  def add(value)
    # @position = 0 if @position >= @size
    # @values.put(@position,value)
    # @position += 1
    # @overal_position += @range
    
    @add_at_next = 0 unless @add_at_next
    add_at @add_at_next, value
    #@add_at_next += 1
  end

  def update_at(index, value)
    add_at index, value, :update_position => false
  end

  def rotate(previous_index, val)
    @after_rotate.call(previous_index,val) if val
  end

  def prev_index(index)
    index - (@size * @range)
  end

  def each_with_index
    order_values = values
    order_values.each_with_index do |v,i|
      # p "#{v}, #{i} , #{order_values[i]}"
      yield order_values[i], min_index + (i*@range)
    end
  end

  def add_at(index,value,options={})
    @add_at_next = index + 1
    update_position = options[:update_position] || true
    pos = ((index/@range) % @size)

    if in_limits?(index)
      set_value(pos,value)
      if index >= max_index
        @overal_position = index
        if update_position
          @position = pos + 1 if @position < pos
        end
      end
    elsif out_of_range?(index)
        if @after_rotate
          each_with_index do |val,idx|
            # rotate(min_index + (i*@range),@values.get(pos))
            rotate(idx,val)
          end
        end
        @values.fill_with_nils
        set_value(pos,value)
        @position = @size if update_position
        @overal_position = index + (@size-pos)
    elsif higher?(index)
        rotate(prev_index(index),@values.get(pos)) if @after_rotate
        # set_value(pos,value)
        (pos-1).downto(@position) do |i|
          @values.put(i,nil)
        end if @overal_position >= @size
        @values.put(pos,nil) # We clean the value, if not it gets used by @before_add
        set_value(pos,value)
        @position = pos + 1 if update_position
        @overal_position = index
    elsif lower?(index)
        rotate(prev_index(index),@values.get(pos)) if @after_rotate
        # set_value(pos,value)
        clean =  min_index-1-index
        (0).upto(clean-1) do |i|
          @values.put((pos + i) % @size, nil)
        end
        @values.put(pos,nil) # We clean the value, if not it gets used by @before_add

        (0).upto(@position-1) do |i|
          @values.put(i,nil)
        end if @overal_position >= @size
        set_value(pos,value)
        @position = pos if update_position
        @overal_position = @overal_position - (clean * @range)
    else
      raise "Strange.. #{index} is not in limites, not out of range, nor higher, nor lower. Something must be wrong"
    end
  end

  def min_index
    if max_index <= index_size
      0
    else
      (max_index + 1) - index_size + remaining_in_slot
    end
  end

  def remaining_in_slot
    (@range - (max_index % @range)) - 1
  end

  def index_size
    @size*@range
  end

  def max_index
    @overal_position
  end

  def values
    if @overal_position < (@size*@range)
      @values.raw
    else
      @values.start_at(@position)
    end
  end

  def raw_values
    # @values
    @values.raw
  end

  def before_add(&block)
    @before_add_list  = block
  end

  def after_rotate(&block)
    @after_rotate = block
  end

  # def dump_to(file_path)
  #   data = dump
  #   File.open(file_path,"w") do |f|
  #     f.write Marshal.dump(data)
  #   end
  # end

  def dump
    {
      size: self.size,
      range: self.range,
      values:self.raw_values,
      position: self.position,
      overal_position: self.overal_position,
      before_add: @before_add_name
    }
  end

  def self.load(data)
    RRList.new(data)
  end

  def self.load_from(file_path)
    load(Marshal.load(File.open(file_path,"r").read))
  end

   # def move_cursor_to(index)
  #   @position = ((index/@range) % @size)
  # end

  # def move_foward
  #   if @position >= @size
  #     move_first
  #   else
  #     @position += 1
  #   end
  # end

  # def move_back
  #   if @position == 0
  #     move_last
  #   else
  #     @position -= 1
  #   end
  # end

  # def move_first
  #   @position = 0
  # end

  # def move_last
  #   @position = @size-1
  # end

  # def load(values,position,overal_position)
  #   @values.set_values(values)
  #   @position = position
  #   @overal_position = overal_position
  # end
  
  def to_s
    {
      range: @range,
      size: @size
    }
  end

 private

  def set_value(index,val,update_position=true)
    if @before_add_list
      adding = @before_add_list.call(index,@values.get(index),val)
      @values.put(index, adding)
    else
      @values.put(index,val)
    end
  end

end

module RRListStore
  class InMemoryArray

    def initialize
      @values = []
    end

    def set_values(values)
      @values = values
    end

    def put(index,value)
      @values[index] = value
      nil
    end

    def get(index)
      @values[index]
    end

    def fill_with_nils
      @values.fill(nil)
      nil
    end

    def fill(value, range)
      @values.fill(value,range)
      nil
    end

    def raw
      @values
    end

    def start_at(position)
      @values[position..@values.size] + @values[0...position]
    end

  end
end
