Before do
  User.new(display_name: 'cong', email: 'example@gmail.com', password: 'password', password_confirmation: 'password').save
end

Given("Im on {string}") do |page_path|
  visit new_user_session_path
end

When("I fill in {string} with {string}") do |field, value|
  fill_in(field, with: value)
end

When("I press {string}") do |button|
  click_button(button)
end

Then("I should be on the {string} page") do |page_name|
  current_path.should == root_path
end