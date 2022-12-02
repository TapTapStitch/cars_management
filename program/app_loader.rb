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
    'log in' => :login_user,
    'sign up' => :register_user,
    'log out' => :log_out,
    'my searches' => :user_searches,
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
    statistic.find_statistic(@authentication.user_email)
    ResultsPrinter.new(statistic, car_finder).output_results
  end

  def log_out
    return unless @login

    @authentication.log_out
    @login = @authentication.login
  end

  def menu_call_condition
    @login = @authentication.login
    MenuOptionsPrinter.new.show_menu_options(@login)
  end

  def login_user
    @authentication.login_user unless @login
  end

  def register_user
    @authentication.register_user unless @login
  end

  def user_searches
    @authentication.user_searches if @login
  end

  def menu_case # rubocop:disable Metrics/CyclomaticComplexity
    case MENU_OPTIONS_MAPPER[gets.chomp]
    when :find_car then find_car
    when :print_all_cars then CarsPrinter.new.output_cars
    when :login_user then login_user
    when :register_user then register_user
    when :log_out then log_out
    when :user_searches then user_searches
    when :show_menu_help then MenuOptionsPrinter.new.show_menu_help
    when :exit_program then exit_program
    end
  end

  def menu_call
    loop do
      menu_call_condition
      menu_case
    end
  end

  def exit_program
    puts I18n.t(:menu_show_exit).colorize(:red)
    exit
  end
end
