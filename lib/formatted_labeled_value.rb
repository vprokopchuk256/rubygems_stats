require_relative 'formatted_value'

class FormattedLabeledValue
  attr_reader :value, :label, :format, :type

  def initialize value, label, format, type: FormattedValue
    @value = value
    @label = label
    @format = format
    @type = type
  end

  def to_s
    [formatted_label, formatted_value].join(':')
  end

  private

  def formatted_value
    @formatted_value ||= type.new(value, format.for(:value))
  end

  def formatted_label
    @formatted_label ||= FormattedValue.new(label, format.for(:label))
  end
end
