require_relative 'formatted_value'

class FormattedDatetime < FormattedValue
  def initialize value, format
    super(format.format.present? ? value.to_datetime.strftime(date_format(format.format)) : nil, format)
  end

  private

  def date_format format
    case format
      when 'mins', 'mns', 'min' then '%-d %b %y %H:%M'
      when 'hour', 'hrs', 'hs', 'h' then '%-d %b %y %H:00'
      when 'day', 'd', 'days' then '%-d %b %y'
      when 'months', 'mos', 'm', 'month' then '%b %y'
      when 'years', 'yrs', 'yr', 'y' then '%Y year'
      else format
    end
  end
end
