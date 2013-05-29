module RRList
module Functions

  def self.get_function_prod(name)
    FUNCTIONS_PROC[name]
  end

  def self.function(name)
    RRList::Functions::FUNCTIONS_PROC[name] || (raise "Function #{name} cannot be found")
  end

  def self.average(numbers,previous_average,add_average,add_numbers=1)
    numbers = numbers.to_f
    previous_average = previous_average.to_f
    add_average = add_average.to_f

    (((numbers*previous_average )+ (add_average*add_numbers))/(numbers+add_numbers))
  end

  def self.agregate_proc
    Proc.new do |index, old_value, new_value|
      case new_value
        when Hash
          if old_value
            {
              value: RRList::Functions.average(old_value[:size],old_value[:value],new_value[:value],new_value[:size]),
              size: old_value[:size] + new_value[:size]
            }
          else
            {
              value: new_value[:value],
              size: new_value[:size],
            }
          end
        else
           if old_value
            {
              value: RRList::Functions.average(old_value[:size],old_value[:value],new_value),
              size: old_value[:size] + 1
            }
          else
            {
              value: new_value,
              size: 1,
            }
          end
       end
    end
  end

  def self.max
    Proc.new do |index, old_value, new_value|
      old_value.nil? || (new_value > old_value) ? new_value : old_value
    end
  end

  def self.min
    Proc.new do |index, old_value, new_value|
      old_value.nil? || (new_value < old_value) ? new_value : old_value
    end
  end

  def self.sum
    Proc.new do |index, old_value, new_value|
      old_value ? (old_value + new_value) : new_value
    end
  end

  def self.decr
    Proc.new do |index, old_value, new_value|
      old_value ? (old_value - new_value) : new_value
    end
  end


   FUNCTIONS_PROC = {
    avg: RRList::Functions::agregate_proc,
    max: RRList::Functions::max,
    min: RRList::Functions::min,
    incr: RRList::Functions::sum,
    decr: RRList::Functions::decr
    }
end
end