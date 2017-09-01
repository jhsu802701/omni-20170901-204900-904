# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
require 'test_helper'

class UserPasswordResetTest < ActionDispatch::IntegrationTest
  def password_reset_sean_connery(str_input)
    begin_user_password_reset(str_input)
    assert page.has_text?('instructions on how to reset your password')

    # Open and follow instructions
    open_email('sean_connery@example.com')
    current_email.click_link 'Change my password'
    clear_emails # Clear the message queue

    # Provide new password and log in
    assert page.has_css?('title', text: full_title('User: Change Your Password'),
                                  visible: false)
    assert page.has_css?('h1', text: 'User: Change Your Password')
    assert page.has_text?('password management program')
    assert page.has_text?('create much better passwords')
    assert page.has_link?('KeePassX', href: 'http://www.keepassx.org')
    fill_in('user_password', with: 'James Bond')
    fill_in('user_password_confirmation', with: 'James Bond')
    click_on 'Change my password'
    assert page.has_text?('Your password has been changed successfully.')
    assert page.has_text?('You are now signed in.')
    assert page.has_text?('You are logged in as a user (sconnery).')
    click_on 'Logout'

    # Log in under the normal method
    login_user('sconnery', 'James Bond', false)
    click_on 'Logout'
  end

  test 'user password reset page is accessible' do
    visit root_path
    click_on 'Login'
    assert page.has_link?('Forgot your password?', href: new_user_password_path)
  end

  test 'user password reset page has the expected content' do
    visit root_path
    click_on 'Login'
    click_on 'Forgot your password?'
    assert page.has_css?('title', text: full_title('User: Reset Forgotten Password'), visible: false)
    assert page.has_css?('h1', text: 'User: Reset Forgotten Password')
    assert page.has_text?('Enter your username or email address.')
  end

  test 'successfully resets user password with email address' do
    password_reset_sean_connery('sean_connery@example.com')
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
