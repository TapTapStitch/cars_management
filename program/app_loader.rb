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
require_relative 'modules/menu_options'
require_relative 'modules/authentication'

class CarsManagement
  MENU_OPTIONS_MAPPER = {
    '1' => :find_car,
    '2' => :print_all_cars,
    '3' => :log_in,
    '4' => :sign_up,
    '5' => :show_menu_help,
    '6' => :exit_program
  }.freeze
  MENU_OPTIONS_MAPPER_LOGIN = {
    '1' => :find_car,
    '2' => :print_all_cars,
    '3' => :log_out,
    '4' => :show_menu_help,
    '5' => :exit_program
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
  
  def check_for_login
    @login = @authentication.login
    return unless @login

    menu_login_call
  end

  def log_out
    @authentication.log_out
    @login = @authentication.login
    menu_call
  end

  def menu_call_case
    case MENU_OPTIONS_MAPPER[@authentication.menu_get]
    when :find_car then find_car
    when :print_all_cars then CarsPrinter.new.output_cars
    when :log_in then @authentication.log_in
    when :sign_up then @authentication.sign_up
    when :show_menu_help then @authentication.show_menu_help
    when :exit_program then @authentication.exit_program
    end
  end

  def menu_call_case_login
    case MENU_OPTIONS_MAPPER_LOGIN[@authentication.menu_get]
    when :find_car then find_car
    when :print_all_cars then CarsPrinter.new.output_cars
    when :log_out then log_out
    when :show_menu_help then @authentication.show_menu_help
    when :exit_program then @authentication.exit_program
    end
  end

  def menu_call
    loop do
      check_for_login
      @authentication.menu_options
      menu_call_case
    end
  end

  def menu_login_call
    loop do
      @authentication.menu_options_login
      menu_call_case_login
    end
  end
end
