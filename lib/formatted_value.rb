require 'active_support/all'
require 'colorize'

class FormattedValue
  attr_reader :value, :format

  delegate :align, :color, to: :format

  def initialize(value, format)
    @value = value
    @format = format
  end

  def to_s
    apply_format if value
  end

  def size
    format.size && Integer(format.size) rescue raise "#{format.name.to_s.humanize} size format is invalid"
  end

  private

  def apply_format
    res = value.to_s
    res = res.truncate(size.to_i).public_send(align_method, size) if size
    res = res.colorize(color.to_sym) if color
    res
  end

  def align_method
    ['right', 'r'].include?(align.to_s) ? 'rjust' : 'ljust'
  end
end
