# frozen_string_literal: true

class AdminInput
  attr_reader :make, :model, :year, :odometer, :price, :description

  def read_id_to_delete
    print_message(:delete_input)
    read_input
  end

  def read_id
    print_message(:input_id)
    read_input
  end

  def read_car_params
    puts I18n.t(:input_params).colorize(:blue)
    print_message(:make)
    @make = read_input
    print_message(:model)
    @model = read_input
    print_message(:year)
    @year = read_input.to_i
    print_message(:odometer)
    @odometer = read_input.to_i
    print_message(:price)
    @price = read_input.to_i
    print_message(:description)
    @description = read_input
  end

  private

  def read_input
    gets.chomp
  end

  def print_message(translation_key, color = :blue)
    print I18n.t(translation_key).colorize(color)
  end
end
