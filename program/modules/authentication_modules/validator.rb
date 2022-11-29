# frozen_string_literal: true

class Validator
  VALID_EMAIL_REGEX = /\A[\w+\-.]{5,}+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}+\z/i

  def initialize(password, email, confirm_pass)
    @userdata = Database.read_users
    @userdata ||= []
    @password = password
    @email = email
    @confirm_pass = confirm_pass
  end

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
    @exists = false
    @userdata.each do |record|
      next unless record['email'] == @email

      @exists = true
    end
    @exists
  end
end
