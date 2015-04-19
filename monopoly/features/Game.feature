Feature: Viewing games in progress, game invitations, and creating a new game
  A logged in user should see any games they are a part of
  A logged in user should be able to create a new game

  Scenario: Click new game button to see new game page
    Given I have an account
    And I have clicked Create a New Game link
    Then I should see the new game page

    #  Scenario: A user should be able to invite people to a game
    #Given I have an account
    #And I have clicked Create a New Game link
    #Then I should be able to invite people to a game

    #Scenario: A user should be able to accept invites to a game
    #Given I have an account
    #And I have a game invitation
    #Then I should be able to accept the invitation

    #Scenario: A user should be able to reject an invite to a game
    #Given I have an account
    #And I have a game invitation
    #Then I should be able to reject the invitation

  Scenario: A user should see the status of a game on the game page
    Given I have an account
    And I have a game in progress
    And I have selected a game
    Then I should see the game status

  Scenario: A user should be able to view the game history
    Given I have an account
    And I have a game in progress
    And I have selected a game
    Then I should be able to see the game history

  Scenario: A user should be able to view the owned properties for a game
    Given I have an account
    And I have a game in progress
    And I have selected a game
    And I have selected Owned Properties
    Then I should be able to see the owned properties

  Scenario: A user should be able to roll the dice
    Given I have an account
    And I have a game in progress
    And I have selected a game
    And I have selected Roll Dice
    Then I should be able to see the results of my roll

  Scenario: A user should be able to refresh the game view
    Given I have an account
    And I have a game in progress
    And I have selected a game
    And I have selected Refresh
    Then I should be able to see a refreshed page
