require_relative 'formatted_value'
require_relative 'formatted_label'
require_relative 'formatted_numeric'
require_relative 'formatted_labeled_value'

class FormattedLine
  attr_reader :line, :format, :type

  def initialize line, format, type: FormattedValue
    @line = line
    @format = format
    @type = type
  end

  def to_s
    "#{formatted_caption}#{formatted_caption_separator}#{formatted_stats}"
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
      .join(formatted_content_separator.to_s)
  end

  def formatted_total
    FormattedLabeledValue.new(total, 'total', format.for(:total), type: FormattedNumeric)
  end

  def formatted_stat label, value
    FormattedLabeledValue.new(value, label, format, type: FormattedNumeric)
  end

  def formatted_caption
    type.new(caption, format.for(:caption))
  end

  def formatted_caption_separator
    FormattedLabel.new(format.for(:caption_separator))
  end

  def formatted_content_separator
    FormattedLabel.new(format.for(:content_separator))
  end
end
