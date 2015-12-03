require 'chronic'

class DateParser
  def self.parse str_date
    Chronic.parse(str_date) or raise "Could not parse #{str_date}"
  end
end
