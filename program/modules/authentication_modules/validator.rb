# frozen_string_literal: true

class Validator
  VALID_EMAIL_REGEX = /\A[\w+\-.]{5,}+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}+\z/i

  def initialize(password, email, confirm_pass)
    @userdata = Database.read_users ||= []
    @password = password
    @email = email
    @confirm_pass = confirm_pass
  end

  def success?
    success = true
    @error_array = []
    error_conditions
    unless @error_array.empty?
      error_output
      success = false
    end
    success
  end

  private

  def error_found(error)
    @error_array << error
  end

  def error_output
    @error_array.each do |error|
      puts I18n.t(error).colorize(:red)
    end
  end

  def error_conditions
    error_found(:mistake_mail) unless check_mail
    error_found(:mistake_pass_match) unless password_match?
    error_found(:mistake_pass_valid) unless password_valid?
    error_found(:mistake_mail_exists) if user_exists?
  end

  def password_match?
    @password == @confirm_pass
  end

  def password_valid?
    @password.match? VALID_PASSWORD
  end

  def check_mail
    @email.match? VALID_EMAIL_REGEX
  end

  def user_exists?
    @userdata.any? do |user|
      user['email'] == @email
    end
  end
end
