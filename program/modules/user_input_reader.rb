# frozen_string_literal: true

class UserInput
  ALLOWED_LANGUAGES = %w[en ua].freeze
  DEFAULT_LANGUAGE = :en

  def initialize(default_language: DEFAULT_LANGUAGE)
    @language = default_language
  end

  def read_users_input
    language_input
    language_load
    read_filters_from_user
    read_sort_from_user
    [@make, @model, @year_from, @year_to, @price_from, @price_to, @pre_sort, @pre_direction]
  end

  private

  def print_message(translation_key, color = :blue)
    puts I18n.t(translation_key).colorize(color)
  end

  def read_input
    gets.chomp
  end

  def language_load
    I18n.load_path << Dir[File.expand_path('locales') << '/*.yml']
    I18n.default_locale = @language
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

  def read_year
    print_message(:select_year_from)
    @year_from = read_input
    print_message(:select_year_to)
    @year_to = read_input
  end

  def read_price
    print_message(:select_price_from)
    @price_from = read_input
    print_message(:select_price_to)
    @price_to = read_input
  end

  def read_filters_from_user
    print_message(:select_rules)
    print_message(:select_make)
    @make = read_input
    print_message(:select_model)
    @model = read_input
    read_year
    read_price
  end

  def read_sort_from_user
    print_message(:select_sort_option)
    @pre_sort = read_input
    print_message(:select_sort_direction)
    @pre_direction = read_input
  end
end
