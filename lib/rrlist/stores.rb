module RRList
  module Store
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
end
