Feature: Form
  In order to value
  As a role
  I want feature
  
  @javascript
  Scenario: New Element
    Given I am on the elements page
    When I follow "New Element"
    Then I should be on the new element page
    And I should see "Create Element"
    When I press "Create Element" within "form"
    Then I should see "Title can't be blank"
    When I fill in "Test Title" for "element[title]"
    And I press "Create Element" within "form"
    Then I should see "Show Element"

  @javascript
  Scenario: Edit Element
    Given an element exists with title: "Test Element"
    When I go to that element's edit page
    And I fill in "" for "element[title]"
    And I press "Update Element" within "form"
    Then I should see "Title can't be blank"
    When I fill in "Test Title" for "element[title]"
    And I press "Update Element" within "form"
    Then I should be on that element's page
    And I should see "Test Title"
  # Then put me the raw result
  
  
  

  
