Given(/^I am at the homepage for non\-logged in users$/) do
  visit('/')
end

Given(/^I have filled in the Create Account$/) do
  within("//form[@action='/users']") do
    fill_in('user[email]', :with => 'Test@gmail.com')
    fill_in('user[password]', :with => 'testpw')
    click_button('Sign Up')
  end
end

Then(/^I should see the user's page$/) do
  assert page.has_content?("Welcome")
  assert page.has_content?("Games in Progress")
  assert page.has_content?("Game Invitations")
end

Given(/^I have an account$/) do
  visit('/')
  within("//form[@action='/users']") do
    fill_in('user[email]', :with => 'Test@gmail.com')
    fill_in('user[password]', :with => 'testpw')
    click_button('Sign Up')
  end
end

Given(/^I have filled in the Log In$/) do
  within("//form[@action='/login']") do
    fill_in('user[email]', :with => 'Test@gmail.com')
    fill_in('user[password]', :with => 'testpw')
    click_button('Log In')
  end
end

Given(/^I have filled in the Create Account without email$/) do
  within("//form[@action='/users']") do
    fill_in('user[password]', :with => 'testpw')
    click_button('Sign Up')
  end
end

Given(/^I have filled in the Create Account without password$/) do
  within("//form[@action='/users']") do
    fill_in('user[email]', :with => 'Test@gmail.com')
    click_button('Sign Up')
  end
end

Given(/^I have filled in the Log In incorrectly$/) do
  within("//form[@action='/login']") do
    fill_in('user[email]', :with => 'Test2@gmail.com')
    fill_in('user[password]', :with => 'testpw')
    click_button('Log In')
  end
end

Then(/^I should see the homepage$/) do
  assert page.has_content?("Click below to log in or sign up")
end

Given(/^I have selected log out$/) do
  visit('/logout')
end

Given(/^I have clicked Create a New Game link$/) do
  click_link('Create a New Game')
end

Then(/^I should see the new game page$/) do
  assert page.has_content?("Confirmed Players")
  assert page.has_content?("Invited Players")
end
