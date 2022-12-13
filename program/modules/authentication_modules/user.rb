# frozen_string_literal: true

class User
  def initialize(email, role)
    @email = email
    @role = role
  end

  attr_reader :email, :role
end
