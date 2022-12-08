# frozen_string_literal: true

require_relative 'rake/create_record'
require_relative 'program/modules/database'

task :clear_database do
  open('database/db.yml', File::TRUNC)
  open('database/searches.yml', File::TRUNC)
  open('database/user_searches.yml', File::TRUNC)
  open('database/users.yml', File::TRUNC)
end

task :add_record do
  data = Database.read_cars || []
  data << CreateRecord.call
  Database.update_cars(data)
  puts 'Done'
end

task :add_records do
  amount = ARGV.last
  data = Database.read_cars || []
  amount.to_i.times do
    data << CreateRecord.call
  end
  Database.update_cars(data)
  task amount.to_i do
    puts 'Done'
  end
end
