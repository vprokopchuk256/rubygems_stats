require 'json'
require 'active_support/all'

class ArchiveUpdater
  attr_reader :db

  def initialize db
    @db = db
  end

  def add line
    created_at, gems_stats = JSON.parse(line)

    raise 'Created at is not defined' if created_at.blank?
    raise 'Gems stats is not defined' if gems_stats.blank?

    gems_stats.collect do |gem_name, downloads|
      db.insert name: gem_name, downloads: downloads, created_at: created_at.to_datetime
    end
  end
end
