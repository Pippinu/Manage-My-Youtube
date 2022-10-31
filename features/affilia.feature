Feature: Cerca_affilia M

Scenario: log_in
  Given I am on the Managemyoutube sign up
  When I fill in "Email" with "p9@p"
  When I fill in "Conferma Password" with "unapassword"
  When I fill in "Password (Minimo 6 Caratteri)" with "unapassword"
  When I select "Manager" from "Prova"
  And I press "Signup"
  Then I should be on the Managemyoutube home page
  And I press "Logout"

  Given I am on the Managemyoutube sign up
  When I fill in "Email" with "p92@p"
  When I fill in "Conferma Password" with "unapassword"
  When I fill in "Password (Minimo 6 Caratteri)" with "unapassword"
  And I press "Signup"
  
  Then I should be on the Managemyoutube home page
  When I go to cliente_s_m
  Then I should be on cliente_s_m
  When I go to nuova_affilia