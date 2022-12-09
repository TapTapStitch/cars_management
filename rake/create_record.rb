# frozen_string_literal: true

require 'ffaker'
require 'date'

class CreateRecord
  DATE = Date.today
  def self.call
    {
      'id' => FFaker::Vehicle.vin,
      'make' => FFaker::Vehicle.make,
      'model' => FFaker::Vehicle.model,
      'year' => FFaker::Vehicle.year.to_i,
      'odometer' => FFaker::Random.rand(0..10_000).to_i,
      'price' => FFaker::Random.rand(0..1000).to_i,
      'description' => FFaker::Vehicle.mfg_color,
      'date_added' => "#{DATE.day}/#{DATE.month}/#{DATE.year}"
    }
  end
end
