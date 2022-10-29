require 'yaml'
require 'date'

class CarsManagement
  def find_the_car
    load_file
    ask_user
    ask_sort
    find_car
    sort
    output
  end

  private

  def load_file
    @cars_array = YAML.load(File.read('db.yml'))
  end

  def ask_user
    puts 'Please select search rules.'

    puts 'Please choose make:'
    @make = gets.chomp
    @make = 'skip' if @make == ''
    puts 'Please choose model:'
    @model = gets.chomp
    @model = 'skip' if @model == ''
    puts 'Please choose year_from:'
    @year_from = gets.chomp
    @year_from = 'skip' if @year_from == ''
    puts 'Please choose year_to:'
    @year_to = gets.chomp
    @year_to = 'skip' if @year_to == ''
    puts 'Please choose price_from:'
    @price_from = gets.chomp
    @price_from = 'skip' if @price_from == ''
    puts 'Please choose price_to:'
    @price_to = gets.chomp
    @price_to = 'skip' if @price_to == ''
  end

  def ask_sort
    puts 'Please choose sort option (date_added|price):'
    pre_sort = gets.chomp
    case pre_sort
    when 'date_added'
      @sort = 'date_added'
    when 'price'
      @sort = 'price'
    else
      @sort = 'date_added'
    end
    puts 'Please choose sort direction(desc|asc):'
    pre_direction = gets.chomp
    case pre_direction
    when 'desc'
      @direction = 'desc'
    when 'asc'
      @direction = 'asc'
    else
      @direction = 'desc'
    end
  end
  
  def find_car
    @sorted_array = []
    @cars_array.each_index do |x|
      if if @make == 'skip'
           true
         else
           @cars_array[x]['make'] == @make
         end && if @model == 'skip'
                  true
                else
                  @cars_array[x]['model'] == @model
                end && if @year_from == 'skip'
                         true
                       else
                         @cars_array[x]['year'] >= @year_from.to_i
                       end && if @year_to == 'skip'
                                true
                              else
                                @cars_array[x]['year'] <= @year_to.to_i
                              end && if @price_from == 'skip'
                                       true
                                     else
                                       @cars_array[x]['price'] >= @price_from.to_i
                                     end && if @price_to == 'skip'
                                              true
                                            else
                                              @cars_array[x]['price'] <= @price_to.to_i
                                            end
        @sorted_array.append(@cars_array[x])
      end
    end
  end

  def sort
    case @sort
    when 'price'
      if @direction == 'asc'
        @sorted_array.sort_by! { |i| i['price'] }
      else
        @sorted_array.sort_by! { |i| -i['price'] }
      end
    when 'date_added'

      if @direction == 'asc'
        @sorted_array.sort_by! { |i| DateTime.strptime(i['date_added'], '%d/%m/%y').strftime('%Q').to_i }
      else
        @sorted_array.sort_by! { |i| -DateTime.strptime(i['date_added'], '%d/%m/%y').strftime('%Q').to_i }
      end

    end
  end

  def output
    @sorted_array.each_index do |i|
      puts '----------------------------------'
      puts "Id: #{@sorted_array[i]['id']}"
      puts "Make: #{@sorted_array[i]['make']}"
      puts "Model: #{@sorted_array[i]['model']}"
      puts "Year: #{@sorted_array[i]['year']}"
      puts "Odometer: #{@sorted_array[i]['odometer']}"
      puts "Price: #{@sorted_array[i]['price']}"
      puts "Description: #{@sorted_array[i]['description']}"
      puts "Date added: #{@sorted_array[i]['date_added']}"
      puts '----------------------------------'
    end
  end
end

cars = CarsManagement.new

cars.find_the_car
