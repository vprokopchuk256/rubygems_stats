require_relative 'date_parser'

class QueryBuilder
  attr_reader :table, :type

  def initialize table, type
    @table = table
    @type = type
  end

  def query from:, to:, sort:, zero:
    query = %{
      SELECT *
        FROM (#{base_query(from, to)}) info
       WHERE created_at BETWEEN '#{DateParser.parse(from)}' AND '#{DateParser.parse(to)}'
         AND (downloads = #{zero ? 0 : 1} OR downloads > 0)
       ORDER BY created_at #{sort.to_sym == :desc ? 'DESC' : 'ASC'}
    }
  end

  private

  def base_query from, to
    return %{
      SELECT oi.created_at as created_at,
             oi.name as name,
             oi.downloads - COALESCE(MAX(ii.downloads), 0) as downloads
        FROM #{table} oi LEFT JOIN #{table} ii ON oi.name = ii.name AND ii.created_at < oi.created_at
       WHERE oi.created_at BETWEEN '#{DateParser.parse(from)}' AND '#{DateParser.parse(to)}'
        GROUP BY oi.created_at, oi.name, oi.downloads
    } if type.to_sym != :all

    "SELECT * FROM #{table}"
  end
end
