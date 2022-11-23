# frozen_string_literal: true

class CarsPrinter
  def initialize(cars_array)
    @cars_array = cars_array
  end

  def output_cars
    puts print_cars
  end

  private

  def print_cars
    cars_row = []
    @cars_array.each do |record|
      record.each do |key, value|
        cars_row << [I18n.t(key.to_sym).colorize(:light_yellow), value.to_s.colorize(:cyan)]
      end
      cars_row << :separator
    end
    cars_row.pop
    Terminal::Table.new title: I18n.t(:print_cars).colorize(:light_yellow), rows: cars_row
  end
end
