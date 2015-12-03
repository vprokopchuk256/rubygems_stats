require 'chronic'

class DateParser
  def self.parse date
    case date
      when Date, DateTime, Time then date
      else Chronic.parse(date) or raise "Could not parse #{date}"
    end
  end
end
