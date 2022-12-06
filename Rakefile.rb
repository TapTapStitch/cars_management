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
  date = FFaker::Time.date
  data << { 'id' => FFaker::Vehicle.vin, 'make' => FFaker::Vehicle.make, 'model' => FFaker::Vehicle.model,
            'year' => FFaker::Vehicle.year, 'odometer' => FFaker::Random.rand(0..10_000), 'price' => FFaker::Random.rand(0..1000), 'description' => FFaker::Vehicle.mfg_color, 'date_added' => date.to_s.tr!('-', '/') }
  File.write('database/db.yml', data.to_yaml)
end

task :add_records do
  amount = ARGV.last
  data = YAML.safe_load(File.read('database/db.yml'))
  amount.to_i.times do
    date = FFaker::Time.date
    data << { 'id' => FFaker::Vehicle.vin, 'make' => FFaker::Vehicle.make, 'model' => FFaker::Vehicle.model,
              'year' => FFaker::Vehicle.year, 'odometer' => FFaker::Random.rand(0..10_000), 'price' => FFaker::Random.rand(0..1000), 'description' => FFaker::Vehicle.mfg_color, 'date_added' => date.to_s.tr!('-', '/') }
  end
  File.write('database/db.yml', data.to_yaml)
  task amount.to_i do; end
end