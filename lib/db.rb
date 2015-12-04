require 'sequel'

require_relative 'query_builder'

class Db
  attr_reader :host, :user, :password, :database, :table, :type, :query_builder

  def initialize host:, user:, password:, database:, table:, type: :all
    @host = host
    @user = user
    @password = password
    @database = database
    @table = table
    @type = type
    @query_builder = QueryBuilder.new(table, type)
  end

  def select from:, to:, sort:
    with_info_table do
      scope = db[query_builder.query from: from, to: to, sort: sort]

      res  = scope.each_with_object(Hash.new{|h, k| h[k] = {}}) do |item, res|
        res[item[:created_at]][item[:name]] = item[:downloads]
      end
    end
  end

  def insert data
    with_info_table { |info| info.insert(data) }
  end

  private

  def with_info_table
    db.create_table? table.to_sym do
      String :name
      Integer :downloads
      DateTime :created_at
    end

    yield db[table.to_sym]
  end

  def db
    @db ||= Sequel.mysql2(host: host, user: user, password: password, database: database)
  end
end
