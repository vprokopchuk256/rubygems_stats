require 'active_support/all'
require 'open-uri'
require 'json'

class SearchGemsSelector
  attr_reader :query

  def initialize query
    @query = query
  end

  def data
    @stats ||= open("https://rubygems.org/api/v1/search.json?query=#{query}") do |result|
      result.readlines.each_with_object({}) do |line, res|
        res.merge!(JSON.parse(line).collect{ |gi| [gi['name'], gi['downloads']] }.to_h)
      end
    end
  end
end

