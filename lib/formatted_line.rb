require_relative 'formatted_value'
require_relative 'formatted_integer'
require_relative 'formatted_labeled_value'

class FormattedLine
  attr_reader :line, :format, :type

  def initialize line, format, type: FormattedValue
    @line = line
    @format = format
    @type = type
  end

  def to_s
    "#{formatted_caption} ===> #{formatted_stats}"
  end

  private

  def caption
    line.first
  end

  def stats
    line.last
  end

  def total
    line.last.sum(&:second)
  end

  def formatted_stats
    stats
      .sort_by(&:first)
      .collect{ |label, value| formatted_stat(label, value) }
      .tap{ |r| r << formatted_total if format.total }
      .join('|')
  end

  def formatted_total
    FormattedLabeledValue.new(total, 'total', format.for(:total), type: FormattedInteger)
  end

  def formatted_stat label, value
    FormattedLabeledValue.new(value, label, format, type: FormattedInteger)
  end

  def formatted_caption
    type.new(caption, format.for(:caption))
  end
end
