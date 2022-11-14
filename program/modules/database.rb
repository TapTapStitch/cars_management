# frozen_string_literal: true

class Database
  PATH_TO_DATABASE = 'database/db.yml'
  PATH_TO_SEARCHES = 'database/searches.yml'

  def read_cars
    YAML.safe_load(File.read(PATH_TO_DATABASE))
  end

  def read_searches
    YAML.safe_load(File.read(PATH_TO_SEARCHES))
  end

  def update_searches(searches_array)
    File.write(PATH_TO_SEARCHES, searches_array.to_yaml)
  end
end
