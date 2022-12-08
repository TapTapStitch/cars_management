# frozen_string_literal: true

require_relative 'rake/create_record'
require_relative 'program/modules/database'

desc 'Clear the database'
task :clear_database do
  open('database/db.yml', File::TRUNC)
  open('database/searches.yml', File::TRUNC)
  open('database/user_searches.yml', File::TRUNC)
  open('database/users.yml', File::TRUNC)
end

desc 'Add randomly genereated car entry to the database'
task :add_record do
  data = Database.read_cars || []
  data << CreateRecord.call
  Database.update_cars(data)
  puts 'Done'
end

desc 'Add multiple generated car entries to the database'
task :add_records do
  amount = ARGV.last
  data = Database.read_cars || []
  amount.to_i.times do
    data << CreateRecord.call
  end
  Database.update_cars(data)
  desc 'Output if task is done'
  task amount.to_i do
    puts 'Done'
  end
end
