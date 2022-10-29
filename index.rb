require 'yaml'
require 'date'

class CarsManagement
  def find_the_car
    @cars_array = YAML.load(File.read('db.yml'))
    request_filters
    apply_filters
    check_is_empty
    find_car
    sort
    output
  end

  private

  def request_filters
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

  def apply_filters
    puts 'Please choose sort option (date_added|price):'
    @pre_sort = gets.chomp
    puts 'Please choose sort direction(desc|asc):'
    @pre_direction = gets.chomp
  end

  def check_is_empty
    def is_empty(word)
      word = 'skip' if word == ''
      return word
    end

    @make = is_empty(@make)
    @model = is_empty(@model)
    @year_from = is_empty(@year_from)
    @year_to = is_empty(@year_to)
    @price_from = is_empty(@price_from)
    @price_to = is_empty(@price_to)
    case @pre_sort
    when 'date_added'
      @sort = 'date_added'
    when 'price'
      @sort = 'price'
    else
      @sort = 'date_added'
    end
    case @pre_direction
    when 'desc'
      @direction = 'desc'
    when 'asc'
      @direction = 'asc'
    else
      @direction = 'desc'
    end
  end

  def find_car
    def check_make(x)
      if @make == 'skip'
        return true
      else
        return @cars_array[x]['make'] == @make
      end
    end

    def check_model(x)
      if @model == 'skip'
        return true
      else
        return @cars_array[x]['model'] == @model
      end
    end

    def check_year_from(x)
      if @year_from == 'skip'
        return true
      else
        return @cars_array[x]['year'] >= @year_from.to_i
      end
    end

    def check_year_to(x)
      if @year_to == 'skip'
        return true
      else
        return @cars_array[x]['year'] <= @year_to.to_i
      end
    end

    def check_price_from(x)
      if @price_from == 'skip'
        return true
      else
        return @cars_array[x]['price'] >= @price_from.to_i
      end
    end

    def check_price_to(x)
      if @price_to == 'skip'
        return true
      else
        return @cars_array[x]['price'] <= @price_to.to_i
      end
    end

    @sorted_array = []

    @cars_array.each_index do |x|
      if check_make(x) && check_model(x) && check_year_from(x) && check_year_to(x) && check_price_from(x) && check_price_to(x)
        @sorted_array.append(@cars_array[x])
      end
    end
  end

  def sort
    def price_sort
      if @direction == 'asc'
        @sorted_array.sort_by! { |i| i['price'] }
      else
        @sorted_array.sort_by! { |i| -i['price'] }
      end
    end

    def date_added_sort
      if @direction == 'asc'
        @sorted_array.sort_by! { |i| DateTime.strptime(i['date_added'], '%d/%m/%y').strftime('%Q').to_i }
      else
        @sorted_array.sort_by! { |i| -DateTime.strptime(i['date_added'], '%d/%m/%y').strftime('%Q').to_i }
      end
    end

    case @sort
    when 'price'
      price_sort
    when 'date_added'
      date_added_sort
    end
  end

  def output
    @sorted_array.each do |array|
      puts '----------------------------------'
      puts "Id: #{array['id']}"
      puts "Make: #{array['make']}"
      puts "Model: #{array['model']}"
      puts "Year: #{array['year']}"
      puts "Odometer: #{array['odometer']}"
      puts "Price: #{array['price']}"
      puts "Description: #{array['description']}"
      puts "Date added: #{array['date_added']}"
      puts '----------------------------------'
    end
  end
end

cars = CarsManagement.new

cars.find_the_car
