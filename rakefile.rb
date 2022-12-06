# frozen_string_literal: true

require 'ffaker'
require 'yaml'

task :clear_database do
  open('database/db.yml', File::TRUNC)
  open('database/searches.yml', File::TRUNC)
  open('database/user_searches.yml', File::TRUNC)
  open('database/users.yml', File::TRUNC)
end

task :add_record do
  data = YAML.safe_load(File.read('database/db.yml'))
  data ||= []
  record = {}
  record['id'] = FFaker::Vehicle.vin
  record['make'] = FFaker::Vehicle.make
  record['model'] = FFaker::Vehicle.model
  record['year'] = FFaker::Vehicle.year
  record['odometer'] = FFaker::Random.rand(0..10_000)
  record['price'] = FFaker::Random.rand(0..1000)
  record['description'] = FFaker::Vehicle.mfg_color
  date = FFaker::Time.date
  record['date_added'] = date.to_s.tr!('-', '/')
  data << record
  File.write('database/db.yml', data.to_yaml)
  puts 'Done'
end

task :add_records do
  amount = ARGV.last
  data = YAML.safe_load(File.read('database/db.yml'))
  data ||= []
  amount.to_i.times do
    record = {}
    record['id'] = FFaker::Vehicle.vin
    record['make'] = FFaker::Vehicle.make
    record['model'] = FFaker::Vehicle.model
    record['year'] = FFaker::Vehicle.year
    record['odometer'] = FFaker::Random.rand(0..10_000)
    record['price'] = FFaker::Random.rand(0..1000)
    record['description'] = FFaker::Vehicle.mfg_color
    date = FFaker::Time.date
    record['date_added'] = date.to_s.tr!('-', '/')
    data << record
  end
  File.write('database/db.yml', data.to_yaml)
  task amount.to_i do
    puts 'Done'
  end
end
