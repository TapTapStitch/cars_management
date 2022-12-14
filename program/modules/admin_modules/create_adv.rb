# frozen_string_literal: true

require 'securerandom'

class CreateAdv
  DATE = Date.today

  def initialize
    @id = SecureRandom.uuid
  end

  def call(input, cars_data)
    input.read_car_params
    return unless AdvValidator.new.call(input)

    add_record(cars_data, input)
  end

  private

  def add_record(cars_data, input)
    cars_data << create_record(input)
    Database.update_cars(cars_data)
    puts (I18n.t(:create_success) + @id.to_s).colorize(:green)
  end

  def create_record(input)
    {
      'id' => @id,
      'make' => input.make,
      'model' => input.model,
      'year' => input.year.to_i,
      'odometer' => input.odometer.to_i,
      'price' => input.price.to_i,
      'description' => description(input),
      'date_added' => "#{DATE.day}/#{DATE.month}/#{DATE.year}"
    }
  end

  def description(input)
    if input.description.empty?
      'No description'
    else
      input.description
    end
  end
end
