# frozen_string_literal: true

require_relative '../authentication'
require_relative '../database'

class UserSearches
  def initialize
    @keys_array = %i[total_quantity request_quantity make model year_from year_to price_from price_to]
    @options_array = %w[total_quantity requests_quantity request_make request_model request_year_from request_year_to
                        request_price_from request_price_to]
  end

  def call(login, user_email)
    @searches_array = Database.read_searches
    @login = login
    @user_email = user_email
    find_user_searches
    puts I18n.t(:user_searches_mistake).colorize(:red) if @user_searches.empty?
    return if @user_searches.empty?

    output_user_searches
  end

  private

  def match_by_filter(record)
    record['user_email'] == @user_email
  end

  def find_user_searches
    @user_searches = []
    @user_email ||= ''
    @searches_array.each do |record|
      next unless match_by_filter(record)

      @exists = true
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
