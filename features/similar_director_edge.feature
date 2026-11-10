# Additional edge-case scenario (NOT part of the official hw-starter
# scenarios). It exercises the Similar Movies page when the current movie
# has a director but there is nobody else sharing that director, so the
# rendered list on show_by_director can legitimately be empty.
Feature: similar movies edge cases

  Scenario: a director with no other movies renders the Similar Movies page
    Given the following movies exist:
    | title | rating | director      | release_date |
    | Joker | R      | Todd Phillips | 2019-10-02   |
    Given I am on the details page for "Joker"
    When  I follow "Find Movies With Same Director"
    Then  I should be on the Similar Movies page for "Joker"
    And   I should see "Other Movies by Todd Phillips"
