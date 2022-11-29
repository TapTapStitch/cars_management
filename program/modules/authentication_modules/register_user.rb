# frozen_string_literal: true

require_relative '../database'
require_relative '../user_input'
require_relative 'validator'

class RegisterUser
  def initialize
    @input = UserInput.new
    @login = false
    @userdata = Database.read_users
    @userdata ||= []
  end

  def call
    @input.reg_user
    load_user_input
    @validator = Validator.new(@password, @email, @confirm_pass)
    return if @validator.check_user_mistakes

    create_user
    Database.update_users(@userdata)
    confirmation
    @login
  end

  private

  def load_user_input
    @email = @input.email
    @password = @input.password
    @confirm_pass = @input.confirm_pass
  end

  def create_user
    @new_user = {}
    @new_user['email'] = @email
    crypted_pass = BCrypt::Password.create(@password)
    @new_user['password'] = crypted_pass.to_s
    @userdata << @new_user
  end

  def confirmation
    puts "#{I18n.t(:sign_confirm)}#{@email}!".colorize(:green)
    @login = true
  end
end
