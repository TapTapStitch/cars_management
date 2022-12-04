# frozen_string_literal: true

require_relative 'user_input'
require_relative 'authentication_modules/login_user'
require_relative 'authentication_modules/register_user'
require_relative 'authentication_modules/user_searches'

class Authentication
  attr_reader :login, :user_email

  def initialize
    @login = false
    @login_user = LoginUser.new
    @register_user = RegisterUser.new
    @user_searches = UserSearches.new
  end

  def login_user
    @login = @login_user.call
    @user_email = @login_user.email if @login
  end

  def register_user
    @login = @register_user.call
    @user_email = @register_user.email if @login
  end

  def user_searches
    @user_searches.call(@login, @user_email)
  end

  def create_user_searches(car_finder)
    @user_searches.create_user_searches(car_finder, @user_email)
  end

  def log_out
    puts I18n.t(:log_out_massage).colorize(:red)
    @login = false
    @user_email = ''
  end
end
