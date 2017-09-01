# rubocop:disable Metrics/AbcSize
require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  def post_user_login(username)
    # Flash
    assert page.has_text?('Signed in successfully.')

    # Successful login -> home page
    assert page.has_css?('title', text: full_title(''), visible: false)
    assert page.has_css?('h1', text: 'Home')

    # Special message on home page
    assert page.has_text?("You are logged in as a user (#{username}).")

    # No "Sign up now!" button
    assert_not page.has_link?('Sign up now!', href: new_user_registration_path)

    # No login option available
    assert_not page.has_link?('Login', href: new_user_session_path)
  end

  test 'Home page provides access to user login page' do
    visit root_path
    assert_not page.has_text?('You are logged in')
    assert page.has_link?('Login', href: new_user_session_path)
  end

  test 'User login page has expected content' do
    visit root_path
    click_on 'Login'
    assert page.has_css?('title', text: full_title('User Login'), visible: false)
    assert page.has_css?('h1', text: 'User Login')
    assert page.has_text?('You may log in with your username or with your email address.')
  end

  test 'Unsuccessful user login, no remembering' do
    login_user('sconnery', 'Austin Powers', false)
    assert page.has_text?('Invalid Login or password.')
  end

  test 'Unsuccessful user login, with remembering' do
    login_user('sconnery', 'Austin Powers', false)
    assert page.has_text?('Invalid Login or password.')
  end

  test 'Successful user login with username, no remembering' do
    login_user('sconnery', 'Goldfinger', false)
    post_user_login('sconnery')
    click_on 'Logout'
    assert page.has_text?('Signed out successfully.')
  end

  test 'Successful user login with username, with remembering' do
    login_user('sconnery', 'Goldfinger', true)
    post_user_login('sconnery')
    click_on 'Logout'
    assert page.has_text?('Signed out successfully.')
  end

  test 'Successful user login with email, no remembering' do
    login_user('sean_connery@example.com', 'Goldfinger', false)
    post_user_login('sconnery')
    click_on 'Logout'
    assert page.has_text?('Signed out successfully.')
  end

  test 'Successful user login with email, with remembering' do
    login_user('sean_connery@example.com', 'Goldfinger', true)
    post_user_login('sconnery')
    click_on 'Logout'
    assert page.has_text?('Signed out successfully.')
  end

  test 'Proper response for new user login and logout' do
    sign_up_user('jhiggins', 'Higgins', 'Jonathan',
                 'jhiggins@example.com', 'Zeus and Apollo',
                 'Zeus and Apollo')

    # Logging in before confirmation
    login_user('jhiggins', 'Zeus and Apollo', false)
    assert page.has_text?('You have to confirm your email address before continuing.')

    # Confirmation
    open_email('jhiggins@example.com')
    current_email.click_link 'Confirm my account'
    assert page.has_text?('Your email address has been successfully confirmed.')

    # Logging in after confirmation
    login_user('jhiggins', 'Zeus and Apollo', false)
    post_user_login('jhiggins')
    click_on 'Logout'
    assert page.has_text?('Signed out successfully.')
  end
end
# rubocop:enable Metrics/AbcSize
