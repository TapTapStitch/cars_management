# frozen_string_literal: true

require_relative '../authentication'
require_relative '../database'
require_relative '../car_finder'

class UserSearches
  def initialize
    @keys_array = %i[make model year_from year_to price_from price_to]
    @options_array = %w[make model year_from year_to price_from price_to]
    @searches_array = Database.read_user_searches
    @searches_array ||= []
  end

  def call(login, user_email)
    initialize
    @login = login
    @user_email = user_email
    find_user_searches
    puts I18n.t(:user_searches_mistake).colorize(:red) if @user_searches.empty?
    return if @user_searches.empty?

    output_user_searches
  end

  def create_user_searches(car_finder, user_email)
    initialize
    @user_email = user_email
    @make = car_finder.make
    @model = car_finder.model
    @year_from = car_finder.year_from
    @year_to = car_finder.year_to
    @price_from = car_finder.price_from
    @price_to = car_finder.price_to
    insert_user_searches unless search_exists?
  end

  private

  def search_exists?
    exist = false
    @searches_array.each do |record|
      next unless match_by_filter(record)

      exist = true
    end
    exist
  end

  def make_model(record)
    record['make'] == @make && record['model'] == @model
  end

  def year(record)
    record['year_from'] == @year_from && record['year_to'] == @year_to
  end

  def price(record)
    record['price_from'] == @price_from && record['price_to'] == @price_to
  end

  def match_by_filter(record)
    record['user_email'] == @user_email && make_model(record) && year(record) && price(record)
  end

  def insert_user_searches
    searches_array = {}
    searches_array['user_email'] = @user_email
    searches_array['make'] = @make
    searches_array['model'] = @model
    searches_array['year_from'] = @year_from
    searches_array['year_to'] = @year_to
    searches_array['price_from'] = @price_from
    searches_array['price_to'] = @price_to
    @searches_array << searches_array
    Database.update_user_searches(@searches_array)
  end

  def match_by_filter_email(record)
    record['user_email'] == @user_email
  end

  def find_user_searches
    @user_searches = []
    @user_email ||= ''
    @searches_array.each do |record|
      next unless match_by_filter_email(record)

      @user_searches << record
    end
  end

  def output_user_searches
    rows = []
    @user_searches.each do |record|
      @keys_array.each_with_index do |elem, i|
        rows << [I18n.t(elem).colorize(:light_yellow), record[@options_array[i]].to_s.colorize(:cyan)]
      end
      rows << :separator
    end
    rows.pop
    puts Terminal::Table.new title: I18n.t(:user_searches_title).colorize(:light_yellow), rows: rows
  end

  def printer(keyword)
    I18n.t(keyword).colorize(:cyan)
  end
end
