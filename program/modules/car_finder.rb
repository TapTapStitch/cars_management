# frozen_string_literal: true

class CarFinder
  BY_DATE_ADDED = 'date_added'
  BY_PRICE = 'price'
  ALLOWED_SORT_OPTIONS = [BY_DATE_ADDED, BY_PRICE].freeze
  DIRECTION_ASC = 'asc'
  DIRECTION_DESC = 'desc'
  ALLOWED_DIRECTION_OPTIONS = [DIRECTION_ASC, DIRECTION_DESC].freeze

  def initialize(cars_array, user_input)
    @cars_array = cars_array
    @make = user_input.make
    @model = user_input.model
    @year_from = user_input.year_from
    @year_to = user_input.year_to
    @price_from = user_input.price_from
    @price_to = user_input.price_to
    @pre_sort = user_input.pre_sort
    @pre_direction = user_input.pre_direction
  end

  attr_reader :result_array

  def find_car_records
    prepare_filters
    find_car
    sort
    @result_array
  end

  private

  def empty?(word)
    word.empty? ? 'skip' : word
  end

  def prepare_request_filters
    @make = empty?(@make)
    @model = empty?(@model)
    @year_from = empty?(@year_from)
    @year_to = empty?(@year_to)
    @price_from = empty?(@price_from)
    @price_to = empty?(@price_to)
  end

  def prepare_sort_options
    @sort = ALLOWED_SORT_OPTIONS.include?(@pre_sort) ? @pre_sort : BY_DATE_ADDED
    @direction = ALLOWED_DIRECTION_OPTIONS.include?(@pre_direction) ? @pre_direction : DIRECTION_DESC
  end

  def prepare_filters
    prepare_request_filters
    prepare_sort_options
  end

  def prepare_filter_value(filter_value, filter_condition)
    filter_value == 'skip' || filter_condition
  end

  def check_make(filter)
    prepare_filter_value(@make, filter == @make)
  end

  def check_model(filter)
    prepare_filter_value(@model, filter == @model)
  end

  def check_year_from(filter)
    prepare_filter_value(@year_from, filter >= @year_from.to_i)
  end

  def check_year_to(filter)
    prepare_filter_value(@year_to, filter <= @year_to.to_i)
  end

  def check_price_from(filter)
    prepare_filter_value(@price_from, filter >= @price_from.to_i)
  end

  def check_price_to(filter)
    prepare_filter_value(@price_to, filter <= @price_to.to_i)
  end

  def check_make_model(car_record)
    check_make(car_record['make']) && check_model(car_record['model'])
  end

  def check_year(car_record)
    check_year_from(car_record['year']) && check_year_to(car_record['year'])
  end

  def match_by_filter?(car_record)
    check_make_model(car_record) && check_year(car_record) &&
      check_price_from(car_record['price']) && check_price_to(car_record['price'])
  end

  def find_car
    @result_array = []
    @cars_array.each do |car_record|
      @result_array << car_record if match_by_filter?(car_record)
    end
  end

  def direction
    @direction == 'asc' ? '' : '-'
  end

  def price_sort
    @result_array.sort_by! { |car| "#{direction}#{car['price']}".to_i }
  end

  def date_added_sort
    @result_array.sort_by! do |t|
      "#{direction}#{DateTime.strptime(t['date_added'], '%d/%m/%y').strftime('%Q').to_i}".to_i
    end
  end

  def sort
    case @sort
    when BY_PRICE
      price_sort
    when BY_DATE_ADDED
      date_added_sort
    end
  end
end
