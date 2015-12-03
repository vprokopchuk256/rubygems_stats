require 'active_support/all'
require 'open-uri'
require 'json'

class OwnGemsSelector
  attr_reader :key

  def initialize key
    raise 'RubyGems api key is not defined' unless key

    @key = key
  end

  def data
    @stats ||= open('https://rubygems.org/api/v1/gems.json', 'Authorization' => key) do |result|
      JSON.parse(result.string).collect{ |gi| [gi['name'], gi['downloads']] }.sort_by(&:first)
    end
  end
end

