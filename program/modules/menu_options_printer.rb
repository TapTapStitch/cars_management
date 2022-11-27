# frozen_string_literal: true

class MenuOptionsPrinter
  def show_menu_options
    table = Terminal::Table.new title: I18n.t(:menu_title).colorize(:yellow) do |t|
      t.add_row [1, I18n.t(:menu_search_car).colorize(:light_yellow)]
      t.add_row [2, I18n.t(:menu_show_car).colorize(:light_yellow)]
      t.add_row [3, I18n.t(:log_in).colorize(:light_yellow)]
      t.add_row [4, I18n.t(:sign_up).colorize(:light_yellow)]
      t.add_row [5, I18n.t(:menu_help).colorize(:light_yellow)]
      t.add_row [6, I18n.t(:menu_exit).colorize(:light_yellow)]
      t.style = { all_separators: true }
    end
    puts table
  end

  def show_menu_options_for_logined
    table = Terminal::Table.new title: I18n.t(:menu_title).colorize(:yellow) do |t|
      t.add_row [1, I18n.t(:menu_search_car).colorize(:light_yellow)]
      t.add_row [2, I18n.t(:menu_show_car).colorize(:light_yellow)]
      t.add_row [3, I18n.t(:log_out).colorize(:light_yellow)]
      t.add_row [4, I18n.t(:menu_help).colorize(:light_yellow)]
      t.add_row [5, I18n.t(:menu_exit).colorize(:light_yellow)]
      t.style = { all_separators: true }
    end
    puts table
  end
end
