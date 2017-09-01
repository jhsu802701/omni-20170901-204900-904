require 'timecop'
require 'test_helper'

class UserLockTest < ActionDispatch::IntegrationTest
  N_WARNING = 5 # Number of incorrect logins for triggering warning

  def login_incorrect
    login_user('sconnery', 'Austin Powers', false)
  end

  def login_correct
    login_user('sconnery', 'Goldfinger', false)
  end

  test 'user can be unlocked by time' do
    N_WARNING.times do
      login_incorrect
    end
    assert page.has_text?('You have one more attempt before your account is locked.')

    login_incorrect
    assert page.has_text?('Your account is locked.')

    t_lock = Time.now
    t29 = t_lock + 29.minutes
    t31 = t_lock + 31.minutes

    # 29 minutes after the lock begins
    Timecop.travel(t29)
    login_correct
    assert page.has_text?('Your account is locked.')

    # 31 minutes after the lock begins
    Timecop.travel(t31)
    login_correct
    assert page.has_text?('Signed in successfully.')
    assert page.has_text?('You are logged in as a user (sconnery).')
    Timecop.return
  end

  test 'unlock request page has expected content' do
    visit root_path
    click_on 'Login'
    click_on "Didn't receive unlock instructions?"
    assert page.has_css?('title', text: full_title('User Unlock'), visible: false)
    assert page.has_css?('h1', text: 'User Unlock')
  end

  test 'user can request another unlock link' do
    N_WARNING.times do
      login_incorrect
    end
    assert page.has_text?('You have one more attempt before your account is locked.')

    login_incorrect
    assert page.has_text?('Your account is locked.')

    # Lose email
    clear_emails # Clear the message queue

    # Request unlock instructions
    visit root_path
    click_on 'Login'
    click_on "Didn't receive unlock instructions?"
    fill_in('Email', with: 'sean_connery@example.com')
    click_on 'Resend unlock instructions'

    # Follow unlock instructions
    open_email('sean_connery@example.com')
    current_email.click_link 'Unlock my account'
    assert page.has_text?('Your account has been unlocked successfully.')
    assert page.has_text?('Please sign in to continue.')
    clear_emails # Clear the message queue

    # Login
    login_correct
    assert page.has_text?('Signed in successfully.')
    assert page.has_text?('You are logged in as a user (sconnery).')
    clear_emails # Clear the message queue
  end
end
