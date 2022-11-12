# frozen_string_literal: true

class CarsManagement # rubocop:disable Metrics/ClassLength
  BY_DATE_ADDED = 'date_added'
  BY_PRICE = 'price'
  ALLOWED_SORT_OPTIONS = [BY_DATE_ADDED, BY_PRICE].freeze

  DIRECTION_ASC = 'asc'
  DIRECTION_DESC = 'desc'
  ALLOWED_DIRECTION_OPTIONS = [DIRECTION_ASC, DIRECTION_DESC].freeze

  ALLOWED_LANGUAGES = %w[en ua].freeze
  DEFAULT_LANGUAGE = :en

  PATH_TO_DATABASE = 'database/db.yml'
  PATH_TO_SEARCHES = 'database/searches.yml'

  def initialize(default_language: DEFAULT_LANGUAGE)
    @language = default_language
  end

  def find_the_car
    language_input
    file_read
    language_load
    read_filters_from_user
    read_sort_from_user
    prepare_filters
    find_car
    sort
    print_results
    print_statistic
    update_searches
  end

  private

  def file_read
    @cars_array = YAML.load(File.read(PATH_TO_DATABASE))
    @searches_array = YAML.load(File.read(PATH_TO_SEARCHES))
  end

  def language_load
    I18n.load_path << Dir[File.expand_path('locales') << '/*.yml']
    I18n.default_locale = @language
  end

  def update_searches
    File.open(PATH_TO_SEARCHES, 'w') { |f| f.write @searches_array.to_yaml }
  end

  def assign_language
    if ALLOWED_LANGUAGES.include?(@language_input)
      @language = @language_input.to_sym
    else
      puts 'Default language is english'.colorize(:blue)
    end
  end

  def language_input
    puts 'Chose language (en/ua)'.colorize(:blue)
    @language_input = read_input
    assign_language
  end

  def print_message(translation_key, color = :blue)
    puts I18n.t(translation_key).colorize(color)
  end

  def read_input
    gets.chomp
  end

  def read_filters_from_user
    print_message(:select_rules)
    print_message(:select_make)
    @make = read_input
    print_message(:select_model)
    @model = read_input
    print_message(:select_year_from)
    @year_from = read_input
    print_message(:select_year_to)
    @year_to = read_input
    print_message(:select_price_from)
    @price_from = read_input
    print_message(:select_price_to)
    @price_to = read_input
  end

  def read_sort_from_user
    print_message(:select_sort_option)
    @pre_sort = read_input
    print_message(:select_sort_direction)
    @pre_direction = read_input
  end

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
    exists = false
    @request_quantity = 1
    @searches_array ||= []
    @searches_array.each do |record|
      next unless check_request_match_by_filter(record)

      exists = true
      record['requests_quantity'] += 1
      record['total_quantity'] = @total_quantity
      @request_quantity = record['requests_quantity']
    end
    exists
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

  def statistic_table
    statistic_row = []
    statistic_row << [I18n.t(:total_quantity).colorize(:light_yellow), @total_quantity.to_s.colorize(:cyan)]
    statistic_row << [I18n.t(:request_quantity).colorize(:light_yellow), @request_quantity.to_s.colorize(:cyan)]
    Terminal::Table.new title: I18n.t(:statistic).colorize(:light_yellow), rows: statistic_row
  end

  def print_statistic
    puts(statistic_table) unless @result_array.length.zero?
  end

  def results_table
    results_row = []
    @result_array.each do |record|
      record.each do |key, value|
        results_row << [I18n.t(key.to_sym).colorize(:light_yellow), value.to_s.colorize(:cyan)]
      end
      results_row << :separator
    end
    results_row.pop
    Terminal::Table.new title: I18n.t(:results).colorize(:light_yellow), rows: results_row
  end

  def print_results
    puts(results_table) unless @result_array.length.zero?
  end
end
