# frozen_string_literal: true

require 'ffaker'
require 'yaml'
require 'date'
def today
  date = Date.today
  "#{date.day}/#{date.month}/#{date.year}"
end

def create_record
  id = FFaker::Vehicle.vin
  make = FFaker::Vehicle.make
  model = FFaker::Vehicle.model
  year = FFaker::Vehicle.year.to_i
  odometer = FFaker::Random.rand(0..10_000).to_i
  price = FFaker::Random.rand(0..1000).to_i
  description = FFaker::Vehicle.mfg_color
  { 'id' => id, 'make' => make, 'model' => model, 'year' => year, 'odometer' => odometer, 'price' => price,
    'description' => description, 'date_added' => today }
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
