include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def fill_in_new_user_test()
  fill_in "Name",         with: "Example User"
  fill_in "Email",        with: "user@example.com"
  fill_in "Password",     with: "foobar"
  fill_in "Confirm Password", with: "foobar"
end


# As noted in the comment line, filling in the form doesn’t work when not using Capybara, 
# so to cover this case we allow the user to pass the option no_capybara: true to 
# override the default signin method and manipulate the cookies directly. This is
# necessary when using one of the HTTP request methods directly (get, post, patch, or delete), 
# as we’ll see in Listing 9.45. (Note that the test cookies object isn’t a perfect
# simulation of the real cookies object; in particular, the cookies.permanent method 
# seen in Listing 8.19 doesn’t work inside tests.)
def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    # post sessions_path, :email => user.email, :password => user.password
    user.update_attribute(:remember_token, User.digest(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end


# RSpec matchers => decouple the tests from the implementation
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end
