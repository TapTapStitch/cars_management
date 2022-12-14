# frozen_string_literal: true

require_relative '../database'
require_relative 'adv_validator'

class UpdateAdv
  def initialize(input, cars_data)
    @cars_data = cars_data
    @input = input
    @id = input.read_id
  end

  def call
    puts (I18n.t(:delete_mistake) + @id.to_s).colorize(:red) unless record_exists?
    return unless record_exists?

    @input.read_car_params
    return unless AdvValidator.new.call(@input)

    rewrite_record(@input)
  end

  private

  def rewrite_record(input)
    @cars_data.each do |record|
      next unless record['id'] == @id

      rewrite(record, input)
      record['description'] = input.description unless input.description.empty?
    end
    puts (I18n.t(:update_success) + @id.to_s).colorize(:green)
    Database.update_cars(@cars_data)
  end

  def record_exists?
    @cars_data.any? do |record|
      record['id'] == @id
    end
  end

  def rewrite(record, input)
    record['make'] = input.make
    record['model'] = input.model
    record['year'] = input.year.to_i
    record['odometer'] = input.odometer.to_i
    record['price'] = input.price.to_i
  end
end
