require 'active_support/all'
require 'open-uri'
require 'json'

class ListGemsSelector
  attr_reader :names

  def initialize names
    @names = names
  end

  def data
    @status = names.each_with_object({}) do |name, res|
      open("https://rubygems.org/api/v1/gems/#{name}") do |result|
        gi = JSON.parse(result.string)

        res[gi['name']] = gi['downloads']
      end
    end
  end
end

