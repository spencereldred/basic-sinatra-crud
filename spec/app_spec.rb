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

  scenario "user can register" do
    visit '/'
    click_on "Registration"
    fill_in('username', :with => 'Spencer')
    fill_in('password', :with => '123')
    click_on "Submit"
    expect(page).to have_content("Thank you for registering")
  end
end