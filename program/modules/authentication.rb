# frozen_string_literal: true

require_relative 'user_input'
require_relative 'authentication_modules/login_user'
require_relative 'authentication_modules/register_user'
require_relative 'authentication_modules/user'

class Authentication
  def initialize
    @login_user = LoginUser.new
    @register_user = RegisterUser.new
  end

  def login_user
    @user = @login_user.call
  end

  def register_user
    @user = @register_user.call
  end
end
