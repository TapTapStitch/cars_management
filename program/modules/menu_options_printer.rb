# frozen_string_literal: true

class MenuOptionsPrinter
  def show_menu_options
    table = Terminal::Table.new title: I18n.t(:menu_title).colorize(:yellow) do |t|
      t.add_row [I18n.t(:menu_search_car), 1]
      t.add_row [I18n.t(:menu_show_car), 2]
      t.add_row [I18n.t(:menu_help), 3]
      t.add_row [I18n.t(:menu_exit), 4]
      t.style = { all_separators: true }
    end
    puts table
  end
end
