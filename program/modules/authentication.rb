# frozen_string_literal: true

require_relative 'user_input'
require_relative 'authentication_modules/login_user'
require_relative 'authentication_modules/register_user'

class Authentication
  attr_reader :login, :user_email, :admin

  def initialize
    @login = false
    @admin = false
    @login_user = LoginUser.new
    @register_user = RegisterUser.new
  end

  def login_user
    @login = @login_user.call
    @admin = @login_user.admin if @login
    @user_email = @login_user.email if @login
  end

  def register_user
    @login = @register_user.call
    @user_email = @register_user.email if @login
  end

  def log_out
    puts I18n.t(:log_out_massage).colorize(:red)
    @login = false
    @admin = false
    @user_email = ''
  end
end
