# rubocop:disable Metrics/ParameterLists
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
require 'test_helper'

class AdminResendConfTest < ActionDispatch::IntegrationTest
  def edit(a, uname, e, fname, lname, password_n, password_c)
    edit_admin_start(a)
    fill_in('Username', with: uname)
    fill_in('Email', with: e)
    fill_in('First name', with: fname)
    fill_in('Last name', with: lname)
    fill_in('admin_password', with: password_n)
    fill_in('admin_password_confirmation', with: password_n)
    fill_in('Current password', with: password_c)
    click_button('Update')
    assert page.has_text?('You updated your account successfully,')
    assert page.has_text?('but we need to verify your new email address.')
    assert page.has_text?('Please check your email and follow the confirm link')
    assert page.has_text?('to confirm your new email address.')

    click_on 'Logout'
    clear_emails # Lose the email message

    # Request new confirmation
    visit root_path
    click_on 'Login'
    click_on 'Admin Login'
    click_on "Didn't receive confirmation instructions?"
    assert page.has_css?('title', text: full_title('Admin: Resend Confirmation'),
                                  visible: false)
    assert page.has_css?('h1', text: 'Admin: Resend Confirmation')
    fill_in('Email', with: e)
    click_on 'Resend confirmation instructions'

    # Open and follow instructions
    open_email(e)
    current_email.click_link 'Confirm my account'
    clear_emails # Clear the message queue

    login_admin(uname, password_n, false)
    assert page.has_text?('Signed in successfully.')
    click_on 'Logout'
  end

  test 'resend confirmation from super admin changing all params' do
    edit(@a1, 'rwitherspoon', 'reese_witherspoon@example.com',
         'Reese', 'Witherspoon', 'Just Like Heaven', 'endorphins')
  end

  test 'resend confirmation from regular admin changing all params' do
    edit(@a4, 'jcoolidge', 'jennifer_coolidge@example.com',
         'Jennifer', 'Coolidge', 'A Cinderella Story',
         "Neptune's Beauty Nook")
  end
end
# rubocop:enable Metrics/ParameterLists
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
