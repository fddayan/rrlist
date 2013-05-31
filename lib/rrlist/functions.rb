module RRList

  # @author Federico Dayan
  # A helper module that provides some Proc object to be use with RRList::List
  # @example
  #   RRList::List.new :size => 10, :range => 5, &RRList::Functions.max
  #   RRList::List.new :size => 10, :range => 5, &RRList::Functions.incr
  module Functions

    # @return [Proc] A proc to be used in a RRList::List that calculates the average of the values inserted at and index
    def self.avg
      Proc.new do |index, old_value, new_value|
        case new_value
          when Hash
            if old_value
              {
                value: RRList::Functions.calc_average(old_value[:size],old_value[:value],new_value[:value],new_value[:size]),
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
                value: RRList::Functions.calc_average(old_value[:size],old_value[:value],new_value),
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

    # @return [Proc] A proc to be used in a RRList::List that calculates the max of the values inserted at and index
    def self.max
      Proc.new do |index, old_value, new_value|
        old_value.nil? || (new_value > old_value) ? new_value : old_value
      end
    end

    # @return [Proc] A proc to be used in a RRList::List that calculates the min of the values inserted at and index
    def self.min
      Proc.new do |index, old_value, new_value|
        old_value.nil? || (new_value < old_value) ? new_value : old_value
      end
    end

    # @return [Proc] A proc to be used in a RRList::List increments the values inserted at and index
    def self.incr
      Proc.new do |index, old_value, new_value|
        old_value ? (old_value + new_value) : new_value
      end
    end

    # @return [Proc] A proc to be used in a RRList::List decrements the values inserted at and index
    def self.decr
      Proc.new do |index, old_value, new_value|
        old_value ? (old_value - new_value) : new_value
      end
    end

    private
      def self.calc_average(numbers,previous_average,add_average,add_numbers=1)
        numbers = numbers.to_f
        previous_average = previous_average.to_f
        add_average = add_average.to_f

        (((numbers*previous_average )+ (add_average*add_numbers))/(numbers+add_numbers))
      end

  end
end