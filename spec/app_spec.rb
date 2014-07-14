require 'rspec'
require 'capybara'

feature "home page" do
  scenario "has registration button" do
    visit '/'
    expect(page).to have_button("Registration")
  end

  scenario "click on registration and go to form" do
    visit '/'
    expect(page).to have_button("Registration")
    click_on "Registration"
    expect(page).to have_content("Username:")
    expect(page).to have_content("Password:")
  end
end