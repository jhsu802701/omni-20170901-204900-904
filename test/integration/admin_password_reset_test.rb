# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
require 'test_helper'

class AdminPasswordResetTest < ActionDispatch::IntegrationTest
  def password_reset(u, e, p)
    begin_admin_password_reset(e)

    # Open and follow instructions
    open_email(e)
    current_email.click_link 'Change my password'
    clear_emails # Clear the message queue

    # Provide new password and log in
    assert page.has_css?('title', text: full_title('Admin: Change Your Password'),
                                  visible: false)
    assert page.has_css?('h1', text: 'Admin: Change Your Password')
    assert page.has_text?('password management program')
    assert page.has_text?('create much better passwords')
    assert page.has_link?('KeePassX', href: 'http://www.keepassx.org')
    fill_in('admin_password', with: p)
    fill_in('admin_password_confirmation', with: p)
    click_on 'Change my password'
    assert page.has_text?('Your password has been changed successfully.')
    assert page.has_text?('You are now signed in.')
    assert page.has_text?("You are logged in as an admin (#{u}).")
    click_on 'Logout'

    # Log in under the normal method
    login_admin(u, p, false)
    click_on 'Logout'
  end

  test 'admin password reset page is accessible' do
    visit root_path
    click_on 'Login'
    click_on 'Admin Login'
    assert page.has_link?('Forgot your password?', href: new_admin_password_path)
  end

  test 'admin password reset page has the expected content' do
    visit root_path
    click_on 'Login'
    click_on 'Admin Login'
    click_on 'Forgot your password?'
    assert page.has_css?('title', text: full_title('Admin: Reset Forgotten Password'), visible: false)
    assert page.has_css?('h1', text: 'Admin: Reset Forgotten Password')
  end

  test 'successfully resets super admin password' do
    password_reset('ewoods', 'elle_woods@example.com', 'Legally Blonde')
  end

  test 'successfully resets regular admin password' do
    password_reset('erichmond', 'emmett_richmond@example.com', 'Legally Blonde')
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
