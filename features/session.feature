Feature: Login to site
Input data to form
click submit button

Scenario: Login to web with invalid_params
  Given Im on "/users/signin"
  When  I fill in "email" with "example@gmail.com"
  When  I fill in "password" with "password"
  When  I press "Login"
  Then  I should be on the "home" page