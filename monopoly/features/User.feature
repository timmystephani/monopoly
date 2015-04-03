Feature: Creating, logging in, and logging out a user
  A user should be created from an email and password
  Both email and password are required
  No two users with the same email should be able to be created
  A user in the database should be able to log in with the correct credentials
  A user not in the database should not be able to log in
  A logged in user should be able to log out

  Scenario: Create user with valid username and password
    Given I am at the homepage for non-logged in users
    And I have filled in the Create Account
    Then I should see the user's page

  Scenario: Log in user with valid username and password
    Given I have an account
    And I have selected log out
    And I am at the homepage for non-logged in users
    And I have filled in the Log In
    Then I should see the user's page

  Scenario: Create user without email
    Given I have selected log out
    And I am at the homepage for non-logged in users
    And I have filled in the Create Account without email
    Then I should see the homepage

  Scenario: Create user without password
    Given I have selected log out
    And I am at the homepage for non-logged in users
    And I have filled in the Create Account without password
    Then I should see the homepage

  Scenario: Create user with same email should fail
    Given I have an account
    And I have selected log out
    And I am at the homepage for non-logged in users
    And I have filled in the Create Account
    Then I should see the homepage

  Scenario: Log in user with invalid username and password should fail
    Given I have an account
    And I have selected log out
    And I am at the homepage for non-logged in users
    And I have filled in the Log In incorrectly
    Then I should see the homepage

  Scenario: Log out logged in user
    Given I have an account
    And I have selected log out
    And I am at the homepage for non-logged in users
    And I have filled in the Log In
    And I have selected log out
    Then I should see the homepage
