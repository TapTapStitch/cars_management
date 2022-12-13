# frozen_string_literal: true

class MenuOptionsPrinter
  def show_menu_options(user)
    @options_array = ['find car', 'print cars', 'log in', 'sign up', 'help', 'exit']
    @keys_array = %i[menu_search_car menu_show_car log_in sign_up menu_help menu_exit]
    check_for_login(user)
    rows = []
    @keys_array.each_with_index do |value, index|
      rows << [@options_array[index], printer(value)]
    end
    table = Terminal::Table.new title: I18n.t(:menu_title).colorize(:yellow), rows: rows
    table.style = { all_separators: true }
    puts table
  end

  def show_menu_help
    keys_array = %i[show_menu_help1 show_menu_help2 show_menu_help3 show_menu_help4]
    rows = []
    keys_array.each do |value|
      rows << [I18n.t(value).colorize(:blue)]
    end
    table = Terminal::Table.new title: I18n.t(:help_title).colorize(:yellow), rows: rows
    table.style = { all_separators: true }
    puts table
  end

  private

  def printer(keyword)
    I18n.t(keyword).colorize(:light_yellow)
  end

  def check_for_login(user)
    return if user.nil?

    remove_elements
    add_user_elements
    return unless user.role == 'Admin'

    add_admin_elements
  end

  def remove_elements
    @options_array.delete('log in')
    @options_array.delete('sign up')
    @keys_array.delete(:log_in)
    @keys_array.delete(:sign_up)
  end

  def add_user_elements
    @options_array.insert(2, 'log out')
    @keys_array.insert(2, :log_out)
    @options_array.insert(3, 'my searches')
    @keys_array.insert(3, :user_searches)
  end

  def add_admin_elements
    @options_array.insert(4, 'create adv ')
    @keys_array.insert(4, :create_adv)
    @options_array.insert(5, 'update adv ')
    @keys_array.insert(5, :update_adv)
    @options_array.insert(6, 'delete adv ')
    @keys_array.insert(6, :delete_adv)
  end
end
