require_relative 'formatted_value'

class FormattedDatetime < FormattedValue
  def initialize value, format
    super(format.format.present? ? value.to_datetime.strftime(format.format) : nil, format)
  end
end
