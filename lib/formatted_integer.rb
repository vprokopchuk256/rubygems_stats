require_relative 'formatted_value'

class FormattedInteger < FormattedValue
  def initialize(value, format)
    val = value.to_i

    format.color = format.positive_color if val > 0 && format.positive_color
    format.color = format.negative_color if val < 0 && format.negative_color

    super(val, format)
  end
end
