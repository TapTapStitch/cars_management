# frozen_string_literal: true

class CreateAdv
  DATE = Date.today

  def call(input, cars_data)
    input.read_car_params
    return unless AdminValidator.new.call(input)

    @id = FFaker::Vehicle.vin
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
      'description' => create_description(input),
      'date_added' => "#{DATE.day}/#{DATE.month}/#{DATE.year}"
    }
  end

  def create_description(input)
    if input.description.empty?
      'No description'
    else
      input.description
    end
  end
end
