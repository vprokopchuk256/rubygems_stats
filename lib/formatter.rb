require_relative 'out'
require_relative 'format'
require_relative 'formatted_value'
require_relative 'formatted_datetime'
require_relative 'formatted_line'

class Formatter
  attr_reader :lines, :opts

  def initialize lines, opts
    @lines = lines
    @opts = opts
  end

  def out &block
    Out
      .new(&block)
      .out(formatted_title)
      .out(formatted_timestamp)
      .out(formatted_lines)
      .tap{ |o| o.out(formatted_total_line) if opts[:total] }
  end

  private

  def formatted_title
    FormattedValue.new(opts[:title], format(:title))
  end

  def formatted_timestamp
    FormattedDatetime.new(DateTime.now, format(:timestamp))
  end

  def formatted_lines
    lines.collect{ |l| FormattedLine.new(l, format(:line), type: FormattedDatetime) }
  end

  def format name
    Format.for(name).load_from(opts)
  end

  def total_line
    [
      'total',
      lines.collect(&:last).each_with_object(Hash.new{|h, k| h[k] = 0}) do |stat, res|
        res.merge!(stat) { |h, r, s| r.to_i + s.to_i }
      end
    ]
  end

  def total_format
    @total_format ||= begin
      format = format(:total)
      format.total = opts[:line_total] && opts[:total_total]
      format
    end
  end

  def formatted_total_line
    FormattedLine.new(total_line, total_format)
  end
end
