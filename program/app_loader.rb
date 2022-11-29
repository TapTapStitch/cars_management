# frozen_string_literal: true

require 'yaml'
require 'date'
require 'i18n'
require 'terminal-table'
require 'colorize'
require 'bcrypt'

require_relative 'modules/database'
require_relative 'modules/user_input'
require_relative 'modules/car_finder'
require_relative 'modules/statistic_finder'
require_relative 'modules/results_printer'
require_relative 'modules/cars_printer'
require_relative 'modules/menu_options_printer'
require_relative 'modules/authentication'

class CarsManagement
  MENU_OPTIONS_MAPPER = {
    'find car' => :find_car,
    'print cars' => :print_all_cars,
    'log in' => :sign_in,
    'sign up' => :sign_up,
    'log out' => :log_out,
    'help' => :show_menu_help,
    'exit' => :exit_program
  }.freeze

  def initialize
    @authentication = Authentication.new
    @login = false
  end

  def call
    UserInput.new.language_input
    menu_call
  end

  private

  def find_car
    car_finder = CarFinder.new
    car_finder.find_car_records
    statistic = StatisticFinder.new(car_finder)
    statistic.find_statistic
    ResultsPrinter.new(statistic, car_finder).output_results
  end

  def log_out
    return unless @login

    @authentication.log_out
    @login = @authentication.login
  end

  def menu_call_condition
    @login = @authentication.login
    @authentication.menu_options
  end

  def sign_in
    @authentication.sign_in_user unless @login
  end

  def register
    @authentication.register_user unless @login
  end

  def menu_case # rubocop:disable Metrics/CyclomaticComplexity
    case MENU_OPTIONS_MAPPER[gets.chomp]
    when :find_car then find_car
    when :print_all_cars then CarsPrinter.new.output_cars
    when :sign_in then sign_in
    when :sign_up then register
    when :log_out then log_out
    when :show_menu_help then @authentication.show_menu_help
    when :exit_program then @authentication.exit_program
    end
  end

  def menu_call
    loop do
      menu_call_condition
      menu_case
    end
  end
end
