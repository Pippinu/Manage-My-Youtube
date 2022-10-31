Feature:  test

Scenario: sign_up utente
  Given I am on the Managemyoutube sign up
  When I fill in "Email" with "p9@p"
  When I fill in "Conferma Password" with "unapassword"
  When I fill in "Password (Minimo 6 Caratteri)" with "unapassword"
  And I press "Signup"
  Then I should be on the Managemyoutube home page