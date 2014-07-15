require_relative "./../app"
require "capybara/rspec"
ENV["RACK_ENV"] = "test"

Capybara.app = App


RSpec.configure do |config|
  config.before do
    database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])

    database_connection.sql("BEGIN")
  end

  config.after do
    database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])

    database_connection.sql("ROLLBACK")
  end
end

def fill_in_registration_form_and_submit(name)
  visit '/register'
  fill_in "username", with: "#{name}"
  fill_in "password", with: "#{name.downcase}"
  click_on "Submit"
end

def user_logs_in(name)
  fill_in "username", with: "#{name}"
  fill_in "password", with: "#{name.downcase}"
  click_on "login"
end

def create_a_fish(name)
  click_on "Fish"
  fill_in "Name", with: "#{name}"
  fill_in "URL", with: "http://en.wikipedia.org/wiki/#{name}"
  click_on "Submit"
end