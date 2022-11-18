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
require_relative 'modules/print_cars'

class CarsManagement
  def initialize
    @db = Database.new
    @input = UserInput.new
    @input.language_input
    welcome_message
  end

  def call
    menu_option
    menu_get
    menu_logic
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

  def output_cars
    cars_array = @db.read_cars
    PrintCars.new(cars_array).output_cars
  end

  def welcome_message
    row = [[I18n.t(:welcome_message).colorize(:blue)]]
    puts Terminal::Table.new rows: row
  end

  def menu_option
    table = Terminal::Table.new title: I18n.t(:menu_title).colorize(:yellow) do |t|
      t.add_row [I18n.t(:menu_search_car), 1]
      t.add_row [I18n.t(:menu_show_car), 2]
      t.add_row [I18n.t(:menu_help), 3]
      t.add_row [I18n.t(:menu_exit), 4]
      t.style = { all_separators: true }
    end
    puts table
  end

  def menu_get
    @user_input = gets.chomp
  end

  def menu_logic # rubocop:disable Metrics/MethodLength
    case @user_input
    when '1'
      find_car
      call
    when '2'
      output_cars
      call
    when '3'
      puts I18n.t(:menu_show_help).colorize(:blue)
      call
    when '4'
      puts I18n.t(:menu_show_exit).colorize(:red)
    else
      call
    end
  end
end
