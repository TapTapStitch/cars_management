# frozen_string_literal: true

require_relative 'menu_options_printer'
require_relative 'user_input'
require_relative 'authentication_modules/sign_in'
require_relative 'authentication_modules/register_user'

class Authentication
  attr_reader :login

  def initialize
    @login = false
  end

  def sign_in_user
    @login = SignIn.new.call
  end

  def register_user
    @login = RegisterUser.new.call
  end

  def log_out
    puts I18n.t(:log_out_massage).colorize(:red)
    @login = false
  end

  def menu_options
    MenuOptionsPrinter.new.show_menu_options(@login)
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
