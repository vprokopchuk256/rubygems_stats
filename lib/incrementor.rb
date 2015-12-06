class Incrementor
  class ValueIncrementor
    attr_reader :next_value, :previous_value

    def initialize next_value, previous_value
      @next_value = next_value.to_f
      @previous_value = previous_value.to_f
    end

    def simple
      next_value - previous_value
    end

    def percentage
      ( next_value - previous_value ) / previous_value * 100
    end

  end

  attr_reader :lines, :type

  def initialize lines, type: :simple
    @lines = lines
    @type = type
  end

  def execute
    increment
  end

  private

  def increment enum = lines.reverse.to_enum, next_line = enum.next
    previous_line = enum.next rescue next_line

    next_line.last.merge!(previous_line.last) { |_, n, p| ValueIncrementor.new(n, p).public_send(type) }

    increment(enum, previous_line) if previous_line != next_line
  end
end
