# frozen_string_literal: true

require_relative '../user_input'
require_relative '../database'
require_relative 'validator'

class LoginUser
  def initialize
    @input = UserInput.new
  end

  def call
    @userdata = Database.read_users || []
    @input.login_user
    @email = @input.email
    @password = @input.password
    if login_user?
      confirmation
    else
      puts I18n.t(:mistake_user).colorize(:red)
    end
    @user
  end

  private

  def confirmation
    puts "#{I18n.t(:sign_confirm)}#{@email}!".colorize(:green)
    @user = User.new(@email, @role)
  end

  def login_user?
    user_exists?
    @exists_user_mail == @email && @exists_user_pass == @password
  end

  def find_user
    @userdata.each do |record|
      next unless record['email'] == @email

      @exists_user_mail = record['email']
      @exists_user_pass = BCrypt::Password.new(record['password'])
      @role = record['role']
      @exists = true
    end
  end

  def user_exists?
    @exists = false
    find_user
    @exists
  end
end
