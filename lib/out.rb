class Out
  attr_reader :block

  def initialize &block
    @block = block
  end

  def out values
    Array(values).each { |v| block.call(v.to_s) }
    self
  end
end
