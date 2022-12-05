# frozen_string_literal: true

require_relative '../authentication'
require_relative '../database'
require_relative '../car_finder'

class UserSearches
  KEYS_ARRAY = %i[make model year_from year_to price_from price_to].freeze
  OPTIONS_ARRAY = %w[make model year_from year_to price_from price_to].freeze

  def initialize
    @searches_array = Database.read_user_searches
    @searches_array ||= []
  end

  def call(login, user_email)
    @login = login
    @user_email = user_email
    find_user_searches if user_search_exists?
    puts I18n.t(:user_searches_mistake).colorize(:red) unless user_search_exists?
  end

  def create_user_searches(car_finder, user_email)
    @user_email = user_email
    insert_user_searches(car_finder) unless search_exists?(car_finder, user_email)
  end

  private

  def search_exists?(car_finder, user_email)
    @searches_array.any? do |record|
      record['user_email'] == user_email && match_by_filter(record, car_finder)
    end
  end

  def make_model(record, car_finder)
    record['make'] == car_finder.make && record['model'] == car_finder.model
  end

  def year(record, car_finder)
    record['year_from'] == car_finder.year_from && record['year_to'] == car_finder.year_to
  end

  def price(record, car_finder)
    record['price_from'] == car_finder.price_from && record['price_to'] == car_finder.price_to
  end

  def match_by_filter(record, car_finder)
    make_model(record, car_finder) && year(record, car_finder) && price(record, car_finder)
  end

  def insert_user_searches(car_finder)
    user_hash = car_finder.to_h
    user_hash['user_email'] = @user_email
    @searches_array << user_hash
    Database.update_user_searches(@searches_array)
  end

  def match_by_filter_email(record)
    record['user_email'] == @user_email
  end

  def user_search_exists?
    @searches_array.any? do |record|
      record['user_email'] == @user_email
    end
  end

  def find_user_searches
    @user_email ||= ''
    puts I18n.t(:user_searches_title).colorize(:green)
    @searches_array.each do |record|
      next unless match_by_filter_email(record)

      output_user_searches(record)
    end
  end

  def output_user_searches(record)
    rows = []
    KEYS_ARRAY.each_with_index do |elem, i|
      rows << [I18n.t(elem).colorize(:light_yellow), record[OPTIONS_ARRAY[i]].to_s.colorize(:cyan)]
    end
    puts Terminal::Table.new rows: rows
  end

  def printer(keyword)
    I18n.t(keyword).colorize(:cyan)
  end
end
