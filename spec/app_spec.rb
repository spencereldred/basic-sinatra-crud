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
    fill_in_registration_form_and_submit("Spencer")
    expect(page).to have_content("Thank you for registering")
    visit '/'
    expect(page).to have_content("Login")
    expect(page).to have_content("Username:")
    expect(page).to have_content("Password:")
    user_logs_in("Spencer")
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
    user_logs_in("Spencer")
    expect(page).to have_content("Seth Lily Annie")
    expect(page).not_to have_content("Spencer")

  end

  scenario "As a logged in user, I can select ascending or decending order" do
    visit '/'
    fill_in_registration_form_and_submit("Spencer")
    fill_in_registration_form_and_submit("Seth")
    fill_in_registration_form_and_submit("Annie")
    fill_in_registration_form_and_submit("Lily")
    user_logs_in("Spencer")
    expect(page).to have_content("Seth Annie Lily")
    expect(page).not_to have_content("Spencer")
    click_on "ASC"
    expect(page).to have_content("Annie Lily Seth")
    click_on "DESC"
    expect(page).to have_content("Seth Lily Annie")
  end

  scenario "logged in user can delete other users" do
    fill_in_registration_form_and_submit("Seth")
    fill_in_registration_form_and_submit("Adam")
    user_logs_in("Seth")
    expect(page).to have_content("Adam")
    click_on "Adam"
    expect(page).not_to have_content("Adam")
  end

  scenario "logged in user can see a fish header and a link to add fish" do
    fill_in_registration_form_and_submit("Spencer")
    expect(page).not_to have_content("Fish")
    user_logs_in("Spencer")
    expect(page).to have_content("Fish")
    expect(page).to have_link("Add Fish")
  end

  scenario "logged in user can add a fish" do
    fill_in_registration_form_and_submit("Seth")
    user_logs_in("Seth")
    create_a_fish("Sethfish")
    expect(page).to have_content("Sethfish")
  end

  scenario "logged in user can only see their fish" do
    fill_in_registration_form_and_submit("Seth")
    fill_in_registration_form_and_submit("Spencer")
    user_logs_in("Seth")
    create_a_fish("Sethfish")
    expect(page).to have_content("Sethfish")
    click_on "logout"
    user_logs_in("Spencer")
    expect(page).not_to have_content("Sethfish")
  end

end