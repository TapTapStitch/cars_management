# frozen_string_literal: true

class AdvValidator
  VALID_MAKE = /\A[a-z][A-Z]{3,50}+\z/i
  VALID_MODEL = /\A[a-z][A-Z]{3,50}+\z/i
  VALID_YEAR = /\A[0-9]+\z/i
  VALID_ODOMETER = /\A[0-9]+\z/i
  VALID_PRICE = /\A[0-9]+\z/i
  CURRENT_YEAR = Date.today.year

  def call(input)
    if error_catcher(input).empty?
      true
    else
      error_output
      false
    end
  end

  private

  def make_valid?(input)
    input.make.match? VALID_MAKE
  end

  def model_valid?(input)
    input.model.match? VALID_MODEL
  end

  def year_valid?(input)
    (input.year.match? VALID_YEAR) && (input.year.to_i <= CURRENT_YEAR) && (input.year.to_i > 1900)
  end

  def odometer_valid?(input)
    input.odometer.match? VALID_ODOMETER
  end

  def price_valid?(input)
    input.price.match? VALID_PRICE
  end

  def error_catcher(input)
    @errors_array = []
    error_conditions(input)
    @errors_array
  end

  def error_conditions(input)
    error_found(:mistake_make) unless make_valid?(input)
    error_found(:mistake_model) unless model_valid?(input)
    error_found(:mistake_year) unless year_valid?(input)
    error_found(:mistake_odometer) unless odometer_valid?(input)
    error_found(:mistake_price) unless price_valid?(input)
  end

  def error_found(error)
    @errors_array << error
  end

  def error_output
    @errors_array.each do |error|
      puts I18n.t(error).colorize(:red)
    end
  end
end
