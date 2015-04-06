Feature: Viewing games in progress, game invitations, and creating a new game
  A logged in user should see any games they are a part of
  A logged in user should be able to create a new game

  Scenario: Click new game button to see new game page
    Given I have an account
    And I have clicked Create a New Game link
    Then I should see the new game page