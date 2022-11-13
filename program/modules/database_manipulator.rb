# frozen_string_literal: true

class Database
  PATH_TO_DATABASE = 'database/db.yml'
  PATH_TO_SEARCHES = 'database/searches.yml'

  def file_read
    cars_array = YAML.safe_load(File.read(PATH_TO_DATABASE))
    searches_array = YAML.safe_load(File.read(PATH_TO_SEARCHES))
    [cars_array, searches_array]
  end

  def update_searches(searches_array)
    File.write(PATH_TO_SEARCHES, searches_array.to_yaml)
  end
end
