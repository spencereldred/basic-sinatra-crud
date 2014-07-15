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