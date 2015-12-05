class Group
  attr_reader :lines, :func

  def initialize lines, func: :sum
    @lines = lines
    @func = func
  end

  def to_json
    [date, stat].to_json
  end

  private

  def stat
    @stat ||= grouped_by_name.transform_values!{|v| Array(v).public_send(func)}
  end

  def grouped_by_name
    lines.collect(&:last).each_with_object({}) do |s, gs|
      gs.merge!(s) { |k, downloads_array, downloads|
        Array(downloads_array) << downloads
      }
    end
  end

  def date
    lines.first.first
  end
end
