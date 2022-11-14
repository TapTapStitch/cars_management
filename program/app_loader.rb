# frozen_string_literal: true

require 'yaml'
require 'date'
require 'i18n'
require 'terminal-table'
require 'colorize'

require_relative 'modules/database'
require_relative 'modules/user_input'
require_relative 'modules/car_finder'
require_relative 'modules/statistic_finder'
require_relative 'modules/results_printer'

class CarsManagement
  def initialize
    @db = Database.new
    @input = UserInput.new
  end

  def find_car
    cars_array = @db.read_cars
    searches_array = @db.read_searches
    @input.read_users_input
    car_finder = CarFinder.new(cars_array, @input)
    result_array = car_finder.find_car_records
    statistic = StatisticFinder.new(result_array, searches_array, @input)
    statistic.find_statistic
    @db.update_searches(statistic.searches_array)
    ResultsPrinter.new(statistic, car_finder).output_results
  end
end
