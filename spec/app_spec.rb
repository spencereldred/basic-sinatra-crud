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

  scenario "user can register, login and logout" do
    visit '/'
    expect(page).to have_content("Login")
    expect(page).to have_content("Username:")
    expect(page).to have_content("Password:")
    click_on "Registration"
    fill_in('username', :with => 'Spencer')
    fill_in('password', :with => '123')
    click_on "Submit"
    expect(page).to have_content("Thank you for registering")
    visit '/'
    expect(page).to have_content("Login")
    expect(page).to have_content("Username:")
    expect(page).to have_content("Password:")
    fill_in('username', :with => 'Spencer')
    fill_in('password', :with => '123')
    click_on "login"
    expect(page).to have_content("You are logged in")
    expect(page).not_to have_content("Login")
    expect(page).to have_content("Logout")
    click_on "logout"
    expect(page).to have_content("You are logged out")
    expect(page).to have_content("Login")
  end

  scenario "user registers without all the info will get error message" do
    visit '/'
    click_on "Registration"
    fill_in('username', :with => 'Spencer')
    fill_in('password', :with => '')
    click_on "Submit"
    expect(page).to have_content("You need to fill in password")

    visit '/'
    click_on "Registration"
    fill_in('username', :with => '')
    fill_in('password', :with => '123')
    click_on "Submit"
    expect(page).to have_content("You need to fill in username")

    visit '/'
    click_on "Registration"
    fill_in('username', :with => '')
    fill_in('password', :with => '')
    click_on "Submit"
    expect(page).to have_content("You need to fill in username and password")
  end

  scenario "user register with an already used username" do
    fill_in_registration_form_and_submit("Spencer")
    expect(page).to have_content("Thank you for registering")
    fill_in_registration_form_and_submit("Spencer")
    expect(page).to have_content("Username is already in use, choose another username")
  end

  scenario "As a logged in user, I can see a list of users, except myself, on home page" do
    visit '/'
    fill_in_registration_form_and_submit("Spencer")
    fill_in_registration_form_and_submit("Seth")
    fill_in_registration_form_and_submit("Lily")
    fill_in_registration_form_and_submit("Annie")
    fill_in('username', :with => 'Spencer')
    fill_in('password', :with => 'spencer')
    click_on "login"
    expect(page).to have_content("Seth Lily Annie")
    expect(page).not_to have_content("Spencer")

  end

  scenario "As a logged in user, I can select ascending or decending order" do
    visit '/'
    fill_in_registration_form_and_submit("Spencer")
    fill_in_registration_form_and_submit("Seth")
    fill_in_registration_form_and_submit("Annie")
    fill_in_registration_form_and_submit("Lily")
    fill_in('username', :with => 'Spencer')
    fill_in('password', :with => 'spencer')
    click_on "login"
    expect(page).to have_content("Seth Annie Lily")
    expect(page).not_to have_content("Spencer")
    click_on "ASC"
    expect(page).to have_content("Annie Lily Seth")
    click_on "DESC"
    expect(page).to have_content("Seth Lily Annie")
  end

end