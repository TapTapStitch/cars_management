# frozen_string_literal: true

require_relative '../database'
require_relative '../user_input'
require_relative 'validator'

class RegisterUser
  def initialize
    @input = UserInput.new
    @login = false
    @userdata = Database.read_users || []
  end

  attr_reader :email

  def call
    @input.register_user
    read_user_input
    @validator = Validator.new(@password, @email, @confirm_pass)
    return unless @validator.success?

    create_user
    Database.update_users(@userdata)
    confirmation
    @login
  end

  private

  def read_user_input
    @email = @input.email
    @password = @input.password
    @confirm_pass = @input.confirm_pass
  end

  def create_user
    @new_user = {}
    @new_user['email'] = @email
    crypted_pass = BCrypt::Password.create(@password)
    @new_user['password'] = crypted_pass.to_s
    @new_user['status'] = 'User'
    @userdata << @new_user
  end

  def confirmation
    puts "#{I18n.t(:sign_confirm)}#{@email}!".colorize(:green)
    @login = true
  end
end
