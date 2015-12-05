require 'active_support/all'

class Normalizer
  attr_reader :lines

  def initialize lines
    @lines = lines
  end

  def execute
    stats.each{|s| s.reverse_merge!(base)}
  end

  private

  def stats
    @stats ||= lines.collect(&:last)
  end

  def names
    @names ||= stats.flat_map(&:keys).uniq
  end

  def base
    @base ||= names.collect{|n| [n, 0]}.to_h
  end
end

