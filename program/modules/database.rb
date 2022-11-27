# frozen_string_literal: true

class Database
  PATH_TO_DATABASE = 'database/db.yml'
  PATH_TO_SEARCHES = 'database/searches.yml'
  PATH_TO_USERS_FILE = 'database/users.yml'

  def read_cars
    YAML.safe_load(File.read(PATH_TO_DATABASE))
  end

  def read_searches
    YAML.safe_load(File.read(PATH_TO_SEARCHES))
  end

  def update_searches(searches_array)
    File.write(PATH_TO_SEARCHES, searches_array.to_yaml)
  end

  def read_users
    YAML.unsafe_load(File.read(PATH_TO_USERS_FILE))
  end

  def update_users(userdata)
    File.write(PATH_TO_USERS_FILE, userdata.to_yaml)
  end
end
