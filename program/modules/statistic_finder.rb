# frozen_string_literal: true

class StatisticFinder
  def initialize(results_array, searches_array, user_input)
    @result_array = results_array
    @searches_array = searches_array
    @searches_array ||= []
    @make = user_input.make
    @model = user_input.model
    @year_from = user_input.year_from
    @year_to = user_input.year_to
    @price_from = user_input.price_from
    @price_to = user_input.price_to
  end

  attr_reader :total_quantity, :request_quantity, :searches_array

  def find_statistic
    calculate_searches
    [@total_quantity, @request_quantity, @searches_array]
  end

  private

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

  def check_request_match_by_filter(filter)
    check_request_make_model(filter) && check_request_year(filter) && check_request_price(filter)
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
