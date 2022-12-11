# frozen_string_literal: true

require 'date'

class AdminValidator
  VALID_MAKE = /\A[a-z][A-Z]{3,50}+\z/i
  VALID_MODEL = /\A[a-z][A-Z]{3,50}+\z/i
  VALID_YEAR = /\A[0-9]+\z/i
  VALID_ODOMETER = /\A[0-9]+\z/i
  VALID_PRICE = /\A[0-9]+\z/i
  CURRENT_YEAR = Date.today.year

  def call(input)
    if valid?(input)
      true
    else
      puts 'Mistake occurred'
      false
    end
  end

  private

  def valid?(input)
    make_valid?(input) && model_valid?(input) && year_valid?(input) &&
      odometer_valid?(input) && price_valid?(input)
  end

  def make_valid?(input)
    input.make.match? VALID_MAKE
  end

  def model_valid?(input)
    input.model.match? VALID_MODEL
  end

  def year_valid?(input)
    (input.year.to_s.match? VALID_YEAR) && (input.year <= CURRENT_YEAR) && (input.year > 1900)
  end

  def odometer_valid?(input)
    input.odometer.to_s.match? VALID_ODOMETER
  end

  def price_valid?(input)
    input.price.to_s.match? VALID_PRICE
  end
end
