class EmptyLinesCleaner
  attr_reader :lines

  def initialize lines
    @lines = lines
  end

  def execute
    lines.delete_if{ |l| l.last.values.sum == 0 }
  end
end
