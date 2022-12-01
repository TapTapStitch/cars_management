# frozen_string_literal: true

require_relative 'user_input'
require_relative 'authentication_modules/login_user'
require_relative 'authentication_modules/register_user'

class Authentication
  attr_reader :login

  def initialize
    @login = false
  end

  def login_user
    @login = LoginUser.new.call
  end

  def register_user
    @login = RegisterUser.new.call
  end

  def log_out
    puts I18n.t(:log_out_massage).colorize(:red)
    @login = false
  end
end
