# frozen_string_literal: true

require_relative 'database'

class CarsPrinter
  def output_cars
    puts print_cars
  end

  private

  def print_cars
    cars_row = []
    Database.read_cars.each do |record|
      record.each do |key, value|
        cars_row << [I18n.t(key.to_sym).colorize(:light_yellow), value.to_s.colorize(:cyan)]
      end
      cars_row << :separator
    end
    cars_row.pop
    Terminal::Table.new title: I18n.t(:print_cars).colorize(:light_yellow), rows: cars_row
  end
end
