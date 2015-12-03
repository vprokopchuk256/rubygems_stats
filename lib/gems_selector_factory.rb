require_relative 'own_gems_selector'
require_relative 'search_gems_selector'
require_relative 'list_gems_selector'

class GemsSelectorFactory
  attr_reader :key, :query

  def initialize
    @key = nil
    @query = nil
  end

  def parse_options args
    args.on("-k", "--key KEY", "api key") do |k|
      @key = k
    end

    args.on("-q", "--query QUERY", "gem search query") do |q|
      @query = q
    end
  end

  def create
    return SearchGemsSelector.new(query) if query
    return ListGemsSelector.new(ARGV) if ARGV.present?

    return OwnGemsSelector.new(key)
  end
end
