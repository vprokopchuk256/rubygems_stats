require_relative 'formatted_value'
require_relative 'formatted_label'

class FormattedLabeledValue
  attr_reader :value, :label, :format, :type

  def initialize value, label, format, type: FormattedValue
    @value = value
    @label = label
    @format = format
    @type = type
  end

  def to_s
    [formatted_label, formatted_value].join(formatted_separator.to_s)
  end

  private

  def formatted_value
    @formatted_value ||= type.new(value, format.for(:value))
  end

  def formatted_label
    @formatted_label ||= FormattedValue.new(label, format.for(:label))
  end

  def formatted_separator
    @formatted_separator ||= FormattedLabel.new(format.for(:value_separator))
  end
end
