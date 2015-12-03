require 'sequel'

require_relative 'date_parser'

class Db
  attr_reader :host, :user, :password, :database, :table

  def initialize host:, user:, password:, database:, table:
    @host = host
    @user = user
    @password = password
    @database = database
    @table = table
  end

  def select from:, to:, sort:
    scope = info

    scope = scope.where('created_at >= ?', DateParser.parse(from)) if from
    scope = scope.where('created_at <= ?', DateParser.parse(to)) if to
    scope = sort.to_sym == :desc ? scope.reverse_order(:created_at) : scope.order(:created_at)

    res  = scope.each_with_object(Hash.new{|h, k| h[k] = {}}) do |item, res|
      res[item[:created_at]][item[:name]] = item[:downloads]
    end
  end

  def insert data
    info.insert(data)
  end

  private


  def info
    @info ||= create_info_table
  end

  def create_info_table
    db.create_table? table.to_sym do
      String :name
      Integer :downloads
      DateTime :created_at
    end

    db[table.to_sym]
  end

  def db
    @db ||= Sequel.mysql2(host: host, user: user, password: password, database: database)
  end
end
