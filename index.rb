require 'yaml'
require 'date'

class CarsManagement
  def find_the_car
    @cars_array = YAML.load(File.read('db.yml'))
    read_filters_from_user
    read_sort_from_user
    prepare_filters
    find_car
    sort
    output
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
    return word.empty? ? 'skip' : word
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

  DIRECTION1 = 'asc'
  DIRECTION2 = 'desc'
  ALLOWED_DIRECTON_OPTIONS = [DIRECTION1, DIRECTION2].freeze

  def prepare_sort_options
    @sort = ALLOWED_SORT_OPTIONS.include?(@pre_sort) ? @pre_sort : BY_DATE_ADDED
    @direction = ALLOWED_DIRECTON_OPTIONS.include?(@pre_direction) ? @pre_direction : DIRECTION2
  end

  def prepare_filters
    prepare_request_filters
    prepare_sort_options
  end

  def prepare_filter_value(filter_value, filter_condition)
    filter_value == 'skip' || filter_condition
  end

  def check_make(x)
    prepare_filter_value(@make, @cars_array[x]['make'] == @make)
  end

  def check_model(x)
    prepare_filter_value(@model, @cars_array[x]['model'] == @model)
  end

  def check_year_from(x)
    prepare_filter_value(@year_from, @cars_array[x]['year'] >= @year_from.to_i)
  end

  def check_year_to(x)
    prepare_filter_value(@year_to, @cars_array[x]['year'] <= @year_to.to_i)
  end

  def check_price_from(x)
    prepare_filter_value(@price_from, @cars_array[x]['price'] >= @price_from.to_i)
  end

  def check_price_to(x)
    prepare_filter_value(@price_to, @cars_array[x]['price'] <= @price_to.to_i)
  end

  def match_by_filter?
    if check_make(x) && check_model(x) && check_year_from(x) && check_year_to(x) && check_price_from(x) && check_price_to(x)
      return true
    end
  end

  def find_car

    @result_array = []

    @cars_array.each_index do |x|
      if check_make(x) && check_model(x) && check_year_from(x) && check_year_to(x) && check_price_from(x) && check_price_to(x)
        @result_array.append(@cars_array[x])
      end
    end
  end

  def direction
    @direction == 'asc' ? '' : '-'
  end

  def price_sort

    @result_array.sort_by! { |car| "#{direction}#{car['price']}".to_i }
  end

  def date_added_sort
    if @direction == 'asc'
      @result_array.sort_by! { |i| DateTime.strptime(i['date_added'], '%d/%m/%y').strftime('%Q').to_i }
    else
      @result_array.sort_by! { |i| -DateTime.strptime(i['date_added'], '%d/%m/%y').strftime('%Q').to_i }
    end
  end

  def sort
    case @sort
    when 'price'
      price_sort
    when 'date_added'
      date_added_sort
    end
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
