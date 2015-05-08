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
end

Given(/^I have an account$/) do
  visit('/')
  within(:xpath, "//form[@action='/users']") do
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
  assert page.has_content?("Create New Game")
  assert page.has_content?("All Players")
end

Given(/^I have a game in progress$/) do
  click_link('Create a New Game')
  click_link("Create Game")
end

Given(/^I have selected a game$/) do
  page.find('body ul a:first-child').click
  assert page.has_content?("Game of Monopoly")
  assert page.has_content?("Status")
end

Then(/^I should see the game status$/) do
  assert has_content?('Status')
end

Then(/^I should be able to invite people to a game$/) do
  assert page.has_content?("Add another player")
end

Given(/^I have a game invitation$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be able to accept the invitation$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be able to reject the invitation$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be able to see the game history$/) do
  assert has_content? 'History'
end

Given(/^I have selected Owned Properties$/) do
  click_link('Owned Properties')
end

Then(/^I should be able to see the owned properties$/) do
  assert has_content? 'Owned Properties'
end

Given(/^I have selected Roll Dice$/) do
  click_link('Roll Dice')
end

Then(/^I should be able to see the results of my roll$/) do
  assert has_content? 'rolled a'
end

Given(/^I have selected Refresh$/) do
  #click_link('#refresh_link')
  find('#refresh_link').click
end

Given(/^I have clicked yes to purchase the property$/) do
  find('#purchase_property_link_yes').click
end

Given(/^I have rolled dice around the board$/) do
  count = 0
  while true
    click_link('Roll Dice')
    sleep 1
    if count == 50
      break
    elsif has_content? 'Purchase Property?'
      find('#purchase_property_link_yes').click
    elsif has_content? 'Jail Options'
      find('#jail_options_link_pay').click
      #elsif has_content? 'passed GO'
    elsif has_content? '10%'
      find('#income_tax_link_200').click
    end
    sleep 1
    count += 1
  end
  
end

Then(/^I should be able to see a refreshed page$/) do
  assert has_content?('Status')
end

Then(/^I should be able to see that I bought it$/) do
  assert has_content?('bought')
end

Then(/^I should be able to pass go$/) do
  assert has_content?('passed GO')
end



  