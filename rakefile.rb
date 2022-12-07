# frozen_string_literal: true

require 'ffaker'
require 'yaml'

def create_record
  id = FFaker::Vehicle.vin
  make = FFaker::Vehicle.make
  model = FFaker::Vehicle.model
  year = FFaker::Vehicle.year
  odometer = FFaker::Random.rand(0..10_000)
  price = FFaker::Random.rand(0..1000)
  description = FFaker::Vehicle.mfg_color
  date_added = FFaker::Time.date.to_s.tr!('-', '/')
  { 'id' => id, 'make' => make, 'model' => model, 'year' => year, 'odometer' => odometer, 'price' => price,
    'description' => description, 'date_added' => date_added }
end

task :clear_database do
  open('database/db.yml', File::TRUNC)
  open('database/searches.yml', File::TRUNC)
  open('database/user_searches.yml', File::TRUNC)
  open('database/users.yml', File::TRUNC)
end

task :add_record do
  data = YAML.safe_load(File.read('database/db.yml'))
  data ||= []
  data << create_record
  File.write('database/db.yml', data.to_yaml)
  puts 'Done'
end

task :add_records do
  amount = ARGV.last
  data = YAML.safe_load(File.read('database/db.yml'))
  data ||= []
  amount.to_i.times do
    data << create_record
  end
  File.write('database/db.yml', data.to_yaml)
  task amount.to_i do
    puts 'Done'
  end
end
