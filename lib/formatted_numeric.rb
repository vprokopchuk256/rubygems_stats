require 'active_support/all'

require_relative 'formatted_value'

class FormattedNumeric < FormattedValue
  def initialize(value, format)
    val = Float(value || 0)

    format.color = format.positive_color if val > 0 && format.positive_color
    format.color = format.negative_color if val < 0 && format.negative_color

    val = val.to_formatted_s(format.format.to_s.to_sym, precision: format.precision.to_i)

    super(val, format)
  end
end
