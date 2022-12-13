# frozen_string_literal: true

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
require_relative 'modules/authentication_modules/user_searches'
require_relative 'modules/advertisement'

class CarsManagement
  MENU_OPTIONS_MAPPER = {
    'find car' => :find_car,
    'print cars' => :print_all_cars,
    'log in' => :login_user,
    'sign up' => :register_user,
    'log out' => :log_out,
    'my searches' => :user_searches,
    'help' => :show_menu_help,
    'exit' => :exit_program,
    'create adv' => :create_adv,
    'update adv' => :update_adv,
    'delete adv' => :delete_adv
  }.freeze

  def initialize
    @auth = Authentication.new
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
    UserSearches.new.create_user_searches(car_finder, @user_email) if @auth.login
    ResultsPrinter.new(statistic, car_finder).output_results
  end

  def log_out
    return unless @auth.login

    @auth.log_out
  end

  def menu_call_condition
    @user_email = @auth.user_email
    MenuOptionsPrinter.new.show_menu_options({ 'login' => @auth.login, 'admin' => @auth.admin })
  end

  def login_user
    @auth.login_user unless @auth.login
  end

  def register_user
    @auth.register_user unless @auth.login
  end

  def user_searches
    UserSearches.new.call(@auth.login, @user_email) if @auth.login
  end

  def create_adv
    Advertisement.new.create_adv if @auth.admin
  end

  def update_adv
    Advertisement.new.update_adv if @auth.admin
  end

  def delete_adv
    Advertisement.new.delete_adv if @auth.admin
  end

  # rubocop:disable all
  def menu_case
    case MENU_OPTIONS_MAPPER[gets.chomp]
    when :find_car then find_car
    when :print_all_cars then CarsPrinter.new.output_cars
    when :login_user then login_user
    when :register_user then register_user
    when :log_out then log_out
    when :user_searches then user_searches
    when :create_adv then create_adv
    when :update_adv then update_adv
    when :delete_adv then delete_adv
    when :show_menu_help then MenuOptionsPrinter.new.show_menu_help
    when :exit_program then exit_program
    end
  end

  # rubocop:enable all
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
