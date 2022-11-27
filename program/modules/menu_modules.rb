# frozen_string_literal: true

class MenuModules
  def find_user
    @userdata.each do |record|
      next unless record['email'] == @mail

      @exists_user_mail = record['email']
      @exists_user_pass = record['password']
      @exists = true
    end
  end

  def user_exists?
    @exists = false
    find_user
    @exists
  end

  def create_user
    @new_user = {}
    @new_user['email'] = @mail
    crypted_pass = BCrypt::Password.create(@pass)
    @new_user['password'] = crypted_pass
    @userdata << @new_user
  end

  def exit_program
    puts I18n.t(:menu_show_exit).colorize(:red)
    exit
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
end
