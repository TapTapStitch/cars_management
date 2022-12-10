# frozen_string_literal: true

class AdminInput
  def read_id_to_delete
    print I18n.t(:delete_input).colorize(:blue)
    read_input
  end

  private

  def read_input
    gets.chomp
  end
end
