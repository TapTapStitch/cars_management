# frozen_string_literal: true

require 'yaml'
require 'date'
require 'i18n'
require 'terminal-table'
require 'colorize'

require_relative 'modules/database_manipulator'
require_relative 'modules/user_input_reader'
require_relative 'modules/car_finder'
require_relative 'modules/statistic_finder'
require_relative 'modules/output_results'

class CarsManagement
  def initialize
    @db = Database.new
    @input = UserInput.new
  end

  def find_car
    cars_array, searches_array = @db.file_read
    make, model, year_from, year_to, price_from, price_to, pre_sort, pre_direction = @input.read_users_input
    car_finder = CarFinder.new(cars_array, make, model, year_from, year_to, price_from, price_to, pre_sort, pre_direction)
    result_array = car_finder.find_car_records
    statistic = StatisticFinder.new(result_array, searches_array, make, model, year_from, year_to, price_from, price_to)
    total_quantity, request_quantity, searches_array = statistic.find_statistic
    @db.update_searches(searches_array)
    results = ResultsToConsole.new(result_array, total_quantity, request_quantity)
    results.output_results
  end
end
