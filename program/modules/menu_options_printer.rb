# frozen_string_literal: true

class MenuOptionsPrinter
  def show_menu_options
    keys_array = %i[menu_search_car menu_show_car log_in sign_up menu_help menu_exit]
    rows = []
    keys_array.each_with_index do |value, index|
      rows << [index + 1, printer(value)]
    end
    table = Terminal::Table.new title: I18n.t(:menu_title).colorize(:yellow), rows: rows
    table.style = { all_separators: true }
    puts table
  end

  def show_menu_options_login
    keys_array = %i[menu_search_car menu_show_car log_out menu_help menu_exit]
    rows = []
    keys_array.each_with_index do |value, index|
      rows << [index + 1, printer(value)]
    end
    table = Terminal::Table.new title: I18n.t(:menu_title).colorize(:yellow), rows: rows
    table.style = { all_separators: true }
    puts table
  end

  private

  def printer(keyword)
    I18n.t(keyword).colorize(:light_yellow)
  end
end
