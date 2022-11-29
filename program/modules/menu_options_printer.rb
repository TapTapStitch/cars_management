# frozen_string_literal: true

class MenuOptionsPrinter
  def show_menu_options(login)
    @options_array = ['find car', 'print cars', 'log in', 'sign up', 'help', 'exit']
    @keys_array = %i[menu_search_car menu_show_car log_in sign_up menu_help menu_exit]
    if login
      remove_elements
      add_elements
    end
    rows = []
    @keys_array.each_with_index do |value, index|
      rows << [@options_array[index], printer(value)]
    end
    table = Terminal::Table.new title: I18n.t(:menu_title).colorize(:yellow), rows: rows
    table.style = { all_separators: true }
    puts table
  end

  private

  def printer(keyword)
    I18n.t(keyword).colorize(:light_yellow)
  end

  def remove_elements
    @options_array.delete('log in')
    @options_array.delete('sign up')
    @keys_array.delete(:log_in)
    @keys_array.delete(:sign_up)
  end

  def add_elements
    @options_array.insert(2, 'log out')
    @keys_array.insert(2, :log_out)
  end
end
