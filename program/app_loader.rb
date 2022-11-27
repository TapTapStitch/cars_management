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
    '1' => :find_car,
    '2' => :print_all_cars,
    '3' => :log_in,
    '4' => :sign_up,
    '5' => :show_menu_help,
    '6' => :exit_program
  }.freeze
  MENU_OPTIONS_MAPPER_LOGINED = {
    '1' => :find_car,
    '2' => :print_all_cars,
    '3' => :log_out,
    '4' => :show_menu_help,
    '5' => :exit_program
  }.freeze

  def initialize
    @db = Database.new
    @input = UserInput.new
    @menu_printer = MenuOptionsPrinter.new
    @authentication = Authentication.new(@db.read_users)
    @logined = false
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
    exit
  end

  def menu_options
    @menu_printer.show_menu_options
    @input.menu_get
  end

  def menu_options_logined
    @menu_printer.show_menu_options_for_logined
    @input.menu_get
  end

  def check_for_login
    return unless @logined

    menu_logined_call
  end

  def log_in
    @input.log_user
    @authentication.log_in(@input)
    @logined = @authentication.logined
  end

  def sign_up
    @input.reg_user
    @authentication.sign_up(@input)
    @db.update_users(@authentication.userdata)
    @logined = @authentication.logined
  end

  def log_out
    puts I18n.t(:log_out_massage).colorize(:red)
    @logined = false
    menu_call
  end

  def menu_call
    loop do
      check_for_login
      menu_options
      case MENU_OPTIONS_MAPPER[@input.user_input]
      when :find_car then find_car
      when :print_all_cars then print_all_cars
      when :log_in then log_in
      when :sign_up then sign_up
      when :show_menu_help then show_menu_help
      when :exit_program then exit_program
      end
    end
  end

  def menu_logined_call
    loop do
      menu_options_logined
      case MENU_OPTIONS_MAPPER_LOGINED[@input.user_input]
      when :find_car then find_car
      when :print_all_cars then print_all_cars
      when :log_out then log_out
      when :show_menu_help then show_menu_help
      when :exit_program then exit_program
      end
    end
  end
end
