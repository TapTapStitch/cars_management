# frozen_string_literal: true

require_relative 'menu_modules'
require_relative 'menu_options'

class Authentication < MenuModules
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD = /\A
  (?=.{8,})          # Must contain 8 or more characters
  (?=.*\d)           # Must contain a digit
  (?=.*[a-z])        # Must contain a lower case character
  (?=.*[A-Z])        # Must contain an upper case character
/x

  attr_reader :login

  def initialize(userdata, input, db)
    @userdata = userdata
    @userdata ||= []
    @login = false
    @input = input
    @db = db
    @menu_printer = MenuOptions.new
  end

  def log_in
    @input.log_user
    @mail = @input.mail
    @pass = @input.pass
    if login_user?
      confirmation
    else
      puts I18n.t(:mistake_user).colorize(:red)
    end
  end

  def log_out
    puts I18n.t(:log_out_massage).colorize(:red)
    @login = false
  end

  def sign_up
    @input.reg_user
    load_user_input
    return if check_user_mistakes

    create_user
    @db.update_users(@userdata)
    confirmation
  end

  def menu_options
    @menu_printer.show_menu_options
    @input.menu_get
  end

  def menu_options_login
    @menu_printer.show_menu_options_login
    @input.menu_get
  end

  private

  def mistake_found(mistake)
    @mistake_array << mistake
  end

  def mistake_output
    @mistake_array.each do |mistake|
      puts I18n.t(mistake).colorize(:red)
    end
  end

  def mistake_conditions
    mistake_found(:mistake_mail) unless check_mail
    mistake_found(:mistake_pass_match) unless password_match?
    mistake_found(:mistake_pass_valid) unless password_valid?
    mistake_found(:mistake_mail_exists) if user_exists?
  end

  def check_user_mistakes
    mistake = false
    @mistake_array = []
    mistake_conditions
    unless @mistake_array.empty?
      mistake_output
      mistake = true
    end
    mistake
  end

  def login_user?
    user_exists?
    @exists_user_mail == @mail && @exists_user_pass == @pass
  end

  def load_user_input
    @mail = @input.mail
    @pass = @input.pass
    @confirm_pass = @input.confirm_pass
  end

  def confirmation
    puts "#{I18n.t(:sign_confirm)}#{@mail}!".colorize(:green)
    @login = true
  end

  def password_match?
    @pass == @confirm_pass
  end

  def log_in_pass_match
    @pass == @exists_user_pass
  end

  def password_valid?
    @pass.match? VALID_PASSWORD
  end

  def check_mail
    @mail.match? VALID_EMAIL_REGEX
  end
end
