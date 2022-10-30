require 'yaml'
require 'date'

class CarsManagement
  def find_the_car
    @cars_array = YAML.load(File.read('db.yml'))
    @searches_hash = YAML.load(File.read('searches.yml'))
    read_filters_from_user
    read_sort_from_user
    prepare_filters
    find_car
    sort
    output
    File.open('searches.yml', 'w') { |f| f.write @searches_hash.to_yaml }
  end

  private

  def read_filters_from_user
    puts 'Please select search rules.'
    puts 'Please choose make:'
    @make = gets.chomp
    puts 'Please choose model:'
    @model = gets.chomp
    puts 'Please choose year_from:'
    @year_from = gets.chomp
    puts 'Please choose year_to:'
    @year_to = gets.chomp
    puts 'Please choose price_from:'
    @price_from = gets.chomp
    puts 'Please choose price_to:'
    @price_to = gets.chomp
  end

  def read_sort_from_user
    puts 'Please choose sort option (date_added|price):'
    @pre_sort = gets.chomp
    puts 'Please choose sort direction(desc|asc):'
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

  def calculate_searches
    @searches_hash['total_quantity'] += @result_array.length
    output_searches
  end

  def output_searches
    puts '----------------------------------'
    puts 'Statistic:'
    puts "Total Quantity:#{@searches_hash['total_quantity']}"
    puts "Requests quantity:#{'Must be here'}"
    puts '----------------------------------'
  end

  def output
    @result_array.each do |record|
      puts '----------------------------------'
      puts "Id: #{record['id']}"
      puts "Make: #{record['make']}"
      puts "Model: #{record['model']}"
      puts "Year: #{record['year']}"
      puts "Odometer: #{record['odometer']}"
      puts "Price: #{record['price']}"
      puts "Description: #{record['description']}"
      puts "Date added: #{record['date_added']}"
      puts '----------------------------------'
    end
  end
end

cars = CarsManagement.new

cars.find_the_car
