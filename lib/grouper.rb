require_relative 'group'

class Grouper
  attr_reader :group_name, :lines

  def initialize group_name, lines
    @group_name = group_name
    @lines = lines || []
  end

  def run
    groups.each do |g|
      yield g.to_json
    end
  end

  private

  def groups
    parsed_lines.group_by{|l| l.first.to_datetime.strftime(group_format)}.collect do |_, lines|
      Group.new(lines)
    end
  end

  def group_format
    case group_name
      when 'mins', 'mns', 'min' then '%Y%m%d %H:%M'
      when 'hour', 'hrs', 'hs', 'h' then '%Y%m%d %H'
      when 'day', 'd', 'days' then '%Y%m%d'
      when 'months', 'mos', 'm', 'month' then '%Y%m'
      when 'years', 'yrs', 'yr', 'y' then '%Y'
      else group_name
    end
  end

  def parsed_lines
    lines.collect{ |l| JSON.parse(l) }
  end
end
