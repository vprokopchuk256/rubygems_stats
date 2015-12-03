require 'sequel'
require 'active_support/all'

class ArchiveSelector
  attr_reader :from, :to, :last, :sort, :db

  def initialize  db, from:, to:, last:, sort:
    @db = db
    @from = from
    @to = to
    @last = last
    @sort = sort
  end

  def data
    res = db.select(from: from, to: to, sort: sort).to_a.sort_by(&:first)
    res = res.last(last.to_i) if last
    res
  end
end
