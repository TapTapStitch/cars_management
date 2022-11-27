# frozen_string_literal: true

class Authentication
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD = /\A
  (?=.{8,})          # Must contain 8 or more characters
  (?=.*\d)           # Must contain a digit
  (?=.*[a-z])        # Must contain a lower case character
  (?=.*[A-Z])        # Must contain an upper case character
/x

  attr_reader :userdata, :logined

  def initialize(userdata)
    @userdata = userdata
    @userdata ||= []
    @logined = false
  end

  def log_in(user_input)
    @mail = user_input.mail
    @pass = user_input.pass
    if login_user?
      confirmation
    else
      puts I18n.t(:mistake_user).colorize(:red)
    end
  end

  def sign_up(user_input)
    load_user_input(user_input)
    return if check_user_input

    puts I18n.t(:mistake_mail_exists).colorize(:red) if user_exists?
    return if user_exists?

    create_user
    confirmation
  end

  private

  def login_user?
    user_exists?
    @exists_user_mail == @mail && @exists_user_pass == @pass
  end

  def load_user_input(user_input)
    @mail = user_input.mail
    @pass = user_input.pass
    @confirm_pass = user_input.confirm_pass
  end

  def confirmation
    puts "#{I18n.t(:sign_confirm)}#{@mail}!".colorize(:green)
    @logined = true
  end

  def password_match?
    @pass == @confirm_pass
  end

  def log_in_pass_match
    puts @pass == @exists_user_pass
  end

  def password_valid?
    @pass =~ VALID_PASSWORD
  end

  def check_mail
    @mail =~ VALID_EMAIL_REGEX
  end

  def check_user_input
    mistake = false
    if check_mail.nil?
      puts I18n.t(:mistake_mail).colorize(:red)
      mistake = true
    end
    unless password_match?
      puts I18n.t(:mistake_pass_match).colorize(:red)
      mistake = true
    end
    if password_valid?.nil?
      puts I18n.t(:mistake_pass_valid).colorize(:red)
      mistake = true
    end
    mistake
  end

  def find_user
    @userdata.each do |record|
      next unless record['email'] == @mail

      @exists_user_mail = record['email']
      @exists_user_pass = record['password']
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
    @new_user['email'] = @mail
    crypted_pass = BCrypt::Password.create(@pass)
    @new_user['password'] = crypted_pass
    @userdata << @new_user
  end
end
