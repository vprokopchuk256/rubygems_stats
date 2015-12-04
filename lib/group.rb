class Group
  attr_reader :lines

  def initialize lines
    @lines = lines
  end

  def to_json
    [date, stat].to_json
  end

  private

  def date
    lines.first.first
  end

  def stat
    lines.collect(&:last).each_with_object(Hash.new{|h, k| h[k] = 0}) do |s, gs|
      gs.merge!(s) { |_, d1, d2| d1 + d2 }
    end
  end
end
