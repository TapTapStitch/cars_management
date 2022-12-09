# frozen_string_literal: true

require 'yaml'

class Database
  PATH_TO_DATABASE = 'database/db.yml'
  PATH_TO_SEARCHES = 'database/searches.yml'
  PATH_TO_USERS_FILE = 'database/users.yml'
  PATH_TO_USER_SEARCHES = 'database/user_searches.yml'

  def self.read_cars
    YAML.safe_load(File.read(PATH_TO_DATABASE))
  end

  def self.update_cars(data)
    File.write(PATH_TO_DATABASE, data.to_yaml)
  end

  def self.read_searches
    YAML.safe_load(File.read(PATH_TO_SEARCHES))
  end

  def self.update_searches(searches_array)
    File.write(PATH_TO_SEARCHES, searches_array.to_yaml)
  end

  def self.read_users
    YAML.unsafe_load(File.read(PATH_TO_USERS_FILE))
  end

  def self.update_users(userdata)
    File.write(PATH_TO_USERS_FILE, userdata.to_yaml)
  end

  def self.read_user_searches
    YAML.unsafe_load(File.read(PATH_TO_USER_SEARCHES))
  end

  def self.update_user_searches(user_searches)
    File.write(PATH_TO_USER_SEARCHES, user_searches.to_yaml)
  end
end
