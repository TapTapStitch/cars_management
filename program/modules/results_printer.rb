# frozen_string_literal: true

class ResultsPrinter
  def initialize(statistic, car_finder)
    @total_quantity = statistic.total_quantity
    @request_quantity = statistic.request_quantity
    @result_array = car_finder.result_array
  end

  def output_results
    print_results
    print_statistic
  end

  private

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
