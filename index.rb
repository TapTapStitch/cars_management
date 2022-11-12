# frozen_string_literal: true

require 'yaml'
require 'date'
require 'i18n'
require 'terminal-table'
require 'colorize'
require_relative 'program/app'

cars = CarsManagement.new
cars.find_the_car
