# frozen_string_literal: true

require_relative 'menu_options_printer'
require_relative 'user_input'
require_relative 'database'

class Authentication
  VALID_EMAIL_REGEX = /\A[\w+\-.]{5,}+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}+\z/i
  attr_reader :login

  def initialize
    @userdata = Database.read_users
    @userdata ||= []
    @login = false
    @input = UserInput.new
    @menu_printer = MenuOptionsPrinter.new
  end

  def sign_in_user
    @input.log_user
    @email = @input.email
    @password = @input.password
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

  def sign_up_user
    @input.reg_user
    load_user_input
    return if check_user_mistakes

    create_user
    Database.update_users(@userdata)
    confirmation
  end

  def menu_options
    @menu_printer.show_menu_options(@login)
  end

  def menu_get
    @input.menu_get
  end

  def exit_program
    puts I18n.t(:menu_show_exit).colorize(:red)
    exit
  end

  def show_menu_help
    keys_array = %i[show_menu_help1 show_menu_help2 show_menu_help3 show_menu_help4]
    rows = []
    keys_array.each do |value|
      rows << [I18n.t(value).colorize(:blue)]
    end
    table = Terminal::Table.new title: I18n.t(:help_title).colorize(:yellow), rows: rows
    table.style = { all_separators: true }
    puts table
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
    @exists_user_mail == @email && @exists_user_pass == @password
  end

  def load_user_input
    @email = @input.email
    @password = @input.password
    @confirm_pass = @input.confirm_pass
  end

  def confirmation
    puts "#{I18n.t(:sign_confirm)}#{@email}!".colorize(:green)
    @login = true
  end

  def password_match?
    @password == @confirm_pass
  end

  def log_in_pass_match
    @password == @exists_user_pass
  end

  def password_valid?
    @password.match? VALID_PASSWORD
  end

  def check_mail
    @email.match? VALID_EMAIL_REGEX
  end

  def find_user
    @userdata.each do |record|
      next unless record['email'] == @email

      @exists_user_mail = record['email']
      @exists_user_pass = BCrypt::Password.new(record['password'])
      @exists = true
    end
  end

  def user_exists?
    @exists = false
    find_user
    @exists
  end

  def create_user
    @new_user = {}
    @new_user['email'] = @email
    crypted_pass = BCrypt::Password.create(@password)
    @new_user['password'] = crypted_pass.to_s
    @userdata << @new_user
  end
end
