# frozen_string_literal: true

require 'date'
require_relative 'database'
require_relative 'admin_modules/admin_input'
require_relative 'admin_modules/create_adv'
require_relative 'admin_modules/update_adv'

class Advertisement
  def initialize
    @cars_data = Database.read_cars || []
    @input = AdminInput.new
  end

  def create_adv
    CreateAdv.new.call(@input, @cars_data)
  end

  def update_adv
    UpdateAdv.new.call(@input, @cars_data)
  end

  def delete_adv
    @id_to_delete = @input.read_id_to_delete
    puts (I18n.t(:delete_mistake) + @id_to_delete.to_s).colorize(:red) unless record_exists?
    delete_record if record_exists?
  end

  private

  def delete_record
    @cars_data.delete_if do |key|
      key['id'] == @id_to_delete
    end
    puts (I18n.t(:delete_success) + @id_to_delete.to_s).colorize(:green)
    Database.update_cars(@cars_data)
  end

  def record_exists?
    @cars_data.any? do |record|
      record['id'] == @id_to_delete
    end
  end
end
