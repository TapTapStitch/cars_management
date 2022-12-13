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
    @user = nil
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
    return if @user.nil?

    puts I18n.t(:log_out_massage).colorize(:red)
    @user = nil
  end

  def login_user
    @user = @auth.login_user if @user.nil?
  end

  def register_user
    @user = @auth.register_user if @user.nil?
  end

  def user_searches
    return if @user.nil?

    UserSearches.new.call(@user)
  end

  def create_adv
    return if @user.nil?

    Advertisement.new.create_adv if @user.role == 'Admin'
  end

  def update_adv
    return if @user.nil?

    Advertisement.new.update_adv if @user.role == 'Admin'
  end

  def delete_adv
    return if @user.nil?

    Advertisement.new.delete_adv if @user.role == 'Admin'
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
      MenuOptionsPrinter.new.show_menu_options(@user)
      menu_case
    end
  end

  def exit_program
    puts I18n.t(:menu_show_exit).colorize(:red)
    exit
  end
end
