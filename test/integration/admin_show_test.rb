require 'test_helper'

class AdminShowTest < ActionDispatch::IntegrationTest
  def check_profile_disabled(a)
    visit admin_path(a)
    assert page.has_css?('title', text: full_title(''),
                                  visible: false)
    assert page.has_css?('h1', text: 'Home', visible: false)
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def check_own_profile(a)
    login_as(a, scope: :admin)
    visit root_path
    assert page.has_link?('Your Profile', href: admin_path(a))
    click_on 'Logout'
  end

  def check_profile_enabled(a)
    fn = a.first_name
    ln = a.last_name
    un = a.username
    e = a.email
    visit admin_path(a)
    assert page.has_css?('title', text: full_title("Admin: #{fn} #{ln}"),
                                  visible: false)
    assert page.has_css?('h1', text: "Admin: #{fn} #{ln}",
                               visible: false)
    assert page.has_text?("Username: #{un}")
    assert page.has_text?("Email: #{e}")
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  test 'unregistered visitors may not view admin profile pages' do
    check_profile_disabled(@a1)
    check_profile_disabled(@a2)
    check_profile_disabled(@a3)
    check_profile_disabled(@a4)
    check_profile_disabled(@a5)
    check_profile_disabled(@a6)
  end

  test 'user may not view admin profile pages' do
    login_as(@u1, scope: :user)
    check_profile_disabled(@a1)
    check_profile_disabled(@a2)
    check_profile_disabled(@a3)
    check_profile_disabled(@a4)
    check_profile_disabled(@a5)
    check_profile_disabled(@a6)
  end

  test 'regular admin can view all admin profiles' do
    login_as(@a4, scope: :admin)
    check_profile_enabled(@a1)
    check_profile_enabled(@a2)
    check_profile_enabled(@a3)
    check_profile_enabled(@a4)
    check_profile_enabled(@a5)
    check_profile_enabled(@a6)
  end

  test 'super admin can view all admin profiles' do
    login_as(@a1, scope: :admin)
    check_profile_enabled(@a1)
    check_profile_enabled(@a2)
    check_profile_enabled(@a3)
    check_profile_enabled(@a4)
    check_profile_enabled(@a5)
    check_profile_enabled(@a6)
  end

  test 'admins can access their own profiles from the menu bar' do
    check_own_profile(@a1)
    check_own_profile(@a2)
    check_own_profile(@a3)
    check_own_profile(@a4)
    check_own_profile(@a5)
    check_own_profile(@a6)
  end
end
