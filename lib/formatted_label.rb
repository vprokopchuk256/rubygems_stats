require_relative 'formatted_value'

class FormattedLabel < FormattedValue
  def initialize(format)
    super(format.label, format)
  end
end
