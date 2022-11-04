# frozen_string_literal: true
require_relative 'gems.rb'

class CarsManagement
  def find_the_car
    file_read
    read_filters_from_user
    read_sort_from_user
    prepare_filters
    find_car
    sort
    print_results
    file_write
  end

  private

  def file_read
    @cars_array = YAML.load(File.read('db.yml'))
    @searches_array = YAML.load(File.read('searches.yml'))
    I18n.load_path << Dir[File.expand_path("locales") + "/*.yml"]
    I18n.default_locale = :en # (note that `en` is already the default!)
  end

  def file_write
    File.open('searches.yml', 'w') { |f| f.write @searches_array.to_yaml }
  end

  def read_filters_from_user
    puts I18n.t(:select_rules).colorize(:blue)
    puts I18n.t(:select_make).colorize(:blue)
    @make = gets.chomp
    puts I18n.t(:select_model).colorize(:blue)
    @model = gets.chomp
    puts I18n.t(:select_year_from).colorize(:blue)
    @year_from = gets.chomp
    puts I18n.t(:select_year_to).colorize(:blue)
    @year_to = gets.chomp
    puts I18n.t(:select_price_from).colorize(:blue)
    @price_from = gets.chomp
    puts I18n.t(:select_price_to).colorize(:blue)
    @price_to = gets.chomp
  end

  def read_sort_from_user
    puts I18n.t(:select_sort_option).colorize(:blue)
    @pre_sort = gets.chomp
    puts I18n.t(:select_sort_direction).colorize(:blue)
    @pre_direction = gets.chomp
  end

  def is_empty(word)
    word.empty? ? 'skip' : word
  end

  def prepare_request_filters
    @make = is_empty(@make)
    @model = is_empty(@model)
    @year_from = is_empty(@year_from)
    @year_to = is_empty(@year_to)
    @price_from = is_empty(@price_from)
    @price_to = is_empty(@price_to)
  end

  BY_DATE_ADDED = 'date_added'
  BY_PRICE = 'price'
  ALLOWED_SORT_OPTIONS = [BY_DATE_ADDED, BY_PRICE].freeze

  DIRECTION_ASC = 'asc'
  DIRECTION_DESC = 'desc'
  ALLOWED_DIRECTON_OPTIONS = [DIRECTION_ASC, DIRECTION_DESC].freeze

  def prepare_sort_options
    @sort = ALLOWED_SORT_OPTIONS.include?(@pre_sort) ? @pre_sort : BY_DATE_ADDED
    @direction = ALLOWED_DIRECTON_OPTIONS.include?(@pre_direction) ? @pre_direction : DIRECTION_DESC
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

  def match_by_filter?(car_record)
    check_make(car_record['make']) && check_model(car_record['model']) && check_year_from(car_record['year']) && check_year_to(car_record['year']) && check_price_from(car_record['price']) && check_price_to(car_record['price'])
  end

  def find_car
    @result_array = []
    @cars_array.each do |car_record|
      @result_array << car_record if match_by_filter?(car_record)
    end
    calculate_searches
  end

  def direction
    @direction == 'asc' ? '' : '-'
  end

  def price_sort
    @result_array.sort_by! { |car| "#{direction}#{car['price']}".to_i }
  end

  def date_added_sort
    @result_array.sort_by! { |t| "#{direction}#{DateTime.strptime(t['date_added'], '%d/%m/%y').strftime('%Q').to_i}".to_i }
  end

  def sort
    case @sort
    when BY_PRICE
      price_sort
    when BY_DATE_ADDED
      date_added_sort
    end
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

  def check_request_match_by_filter(filter)
    check_request_make(filter) && check_request_model(filter) && check_request_year_from(filter) && check_request_year_to(filter) && check_request_price_from(filter) && check_request_price_to(filter)
  end

  def record_exists?
    @exists = false
    @request_quantity = 1
    @searches_array.each do |record|
      if check_request_match_by_filter(record)
        @exists = true
        record['requests_quantity'] += 1
        @request_quantity = record['requests_quantity']
      end
    end
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
    unless find_total_quantity == 0
      record_exists?
      unless @exists
        create_search_request_statistic
        insert_search_request_statistic
      end
      print_statistic
    end
  end

  def print_statistic
    print_statistic_row = []
    print_statistic_row << [I18n.t(:total_quantity).colorize(:light_yellow), @total_quantity.to_s.colorize(:light_yellow)]
    print_statistic_row << [I18n.t(:request_quantity).colorize(:light_yellow), @request_quantity.to_s.colorize(:light_yellow)]
    statistic_table = Terminal::Table.new :title => I18n.t(:statistic).colorize(:light_yellow), :rows => print_statistic_row
    puts(statistic_table)
  end

  def print_results
    print_results_row = []
    @result_array.each do |record|
      print_results_row << [I18n.t(:id).colorize(:light_yellow), record['id'].to_s.colorize(:light_yellow)]
      print_results_row << [I18n.t(:make).colorize(:light_yellow), record['make'].to_s.colorize(:light_yellow)]
      print_results_row << [I18n.t(:model).colorize(:light_yellow), record['model'].to_s.colorize(:light_yellow)]
      print_results_row << [I18n.t(:year).colorize(:light_yellow), record['year'].to_s.colorize(:light_yellow)]
      print_results_row << [I18n.t(:price).colorize(:light_yellow), record['price'].to_s.colorize(:light_yellow)]
      print_results_row << [I18n.t(:description).colorize(:light_yellow), record['description'].to_s.colorize(:light_yellow)]
      print_results_row << [I18n.t(:date).colorize(:light_yellow), record['date_added'].to_s.colorize(:light_yellow)]
      print_results_row << :separator
    end
    resaults_table = Terminal::Table.new :rows => print_results_row
    puts(resaults_table)
  end
end

cars = CarsManagement.new
cars.find_the_car
