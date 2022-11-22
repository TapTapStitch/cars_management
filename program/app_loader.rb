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
require_relative 'modules/cars_printer'
require_relative 'modules/menu_options_printer'

class CarsManagement
  MENU_OPTIONS_MAPPER = {
    '1' => :find_car,
    '2' => :print_all_cars,
    '3' => :show_menu_help,
    '4' => :exit_program
  }.freeze

  def initialize
    @db = Database.new
    @input = UserInput.new
    @menu_printer = MenuOptionsPrinter.new
  end

  def call
    @input.language_input
    menu_call
  end

  private

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

  def print_all_cars
    cars_array = @db.read_cars
    CarsPrinter.new(cars_array).output_cars
  end

  def show_menu_help
    puts I18n.t(:menu_show_help).colorize(:blue)
  end

  def exit_program
    puts I18n.t(:menu_show_exit).colorize(:red)
  end

  def menu_options
    @menu_printer.show_menu_options
    @input.menu_get
  end

  def menu_call
    loop do
      menu_options
      case MENU_OPTIONS_MAPPER[@input.user_input]
      when :find_car then find_car
      when :print_all_cars then print_all_cars
      when :show_menu_help then show_menu_help
      when :exit_program then break
      end
    end
    exit_program
  end
end
