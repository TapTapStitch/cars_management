# frozen_string_literal: true

require_relative 'database'

class StatisticFinder
  def initialize(car_finder)
    @result_array = car_finder.result_array
    @searches_array = Database.read_searches
    @searches_array ||= []
    @make = car_finder.make
    @model = car_finder.model
    @year_from = car_finder.year_from
    @year_to = car_finder.year_to
    @price_from = car_finder.price_from
    @price_to = car_finder.price_to
  end

  attr_reader :total_quantity, :request_quantity

  def find_statistic(user_email)
    user_email(user_email)
    calculate_searches
    Database.update_searches(@searches_array)
    [@total_quantity, @request_quantity]
  end

  private

  def user_email(user_email)
    @user_email = user_email
    @user_email ||= ''
  end

  def check_request_make(filter)
    filter['request_make'] == @make
  end

  def check_request_model(filter)
    filter['request_model'] == @model
  end

  def check_request_year_from(filter)
    filter['request_year_from'] == @year_from
  end

  def check_request_year_to(filter)
    filter['request_year_to'] == @year_to
  end

  def check_request_price_from(filter)
    filter['request_price_from'] == @price_from
  end

  def check_request_price_to(filter)
    filter['request_price_to'] == @price_to
  end

  def check_request_make_model(filter)
    check_request_make(filter) && check_request_model(filter)
  end

  def check_request_year(filter)
    check_request_year_from(filter) && check_request_year_to(filter)
  end

  def check_request_price(filter)
    check_request_price_from(filter) && check_request_price_to(filter)
  end

  def check_request_user(filter)
    filter['user_email'] == @user_email
  end

  def check_request_match_by_filter(filter)
    check_request_make_model(filter) && check_request_year(filter) &&
      check_request_price(filter) && check_request_user(filter)
  end

  def find_record
    @searches_array.each do |record|
      next unless check_request_match_by_filter(record)

      @exists = true
      record['requests_quantity'] += 1
      record['total_quantity'] = @total_quantity
      @request_quantity = record['requests_quantity']
    end
  end

  def record_exists?
    @exists = false
    @request_quantity = 1
    find_record
    @exists
  end

  def insert_search_request_statistic
    @searches_array << @search_request
  end

  def create_search_request_statistic
    @search_request = {}
    @search_request['total_quantity'] = @total_quantity
    @search_request['requests_quantity'] = 1
    @search_request['request_make'] = @make
    @search_request['request_model'] = @model
    @search_request['request_year_from'] = @year_from
    @search_request['request_year_to'] = @year_to
    @search_request['request_price_from'] = @price_from
    @search_request['request_price_to'] = @price_to
    @search_request['user_email'] = @user_email
  end

  def find_total_quantity
    @total_quantity = @result_array.length
  end

  def calculate_searches
    return unless find_total_quantity.positive? && !record_exists?

    create_search_request_statistic
    insert_search_request_statistic
  end
end
