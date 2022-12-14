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
    read_make_model
    read_y_o_p_d
  end

  private

  def read_make_model
    print_message(:make)
    @make = read_input
    print_message(:model)
    @model = read_input
  end

  def read_y_o_p_d
    print_message(:year)
    @year = read_input
    print_message(:odometer)
    @odometer = read_input
    print_message(:price)
    @price = read_input
    print_message(:description)
    @description = read_input
  end

  def read_input
    gets.chomp
  end

  def print_message(translation_key, color = :blue)
    print I18n.t(translation_key).colorize(color)
  end
end
