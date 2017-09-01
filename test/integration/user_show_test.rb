require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  def check_profile_disabled(u)
    visit user_path(u)
    assert page.has_css?('title', text: full_title(''),
                                  visible: false)
    assert page.has_css?('h1', text: 'Home', visible: false)
  end

  def user_view_other_profile(u1, u2)
    login_as(u1, scope: :user)
    check_profile_disabled(u2)
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def check_profile_enabled(u)
    fn = u.first_name
    ln = u.last_name
    un = u.username
    e = u.email
    visit user_path(u)
    assert page.has_css?('title', text: full_title("User: #{fn} #{ln}"),
                                  visible: false)
    assert page.has_css?('h1', text: "User: #{fn} #{ln}",
                               visible: false)
    assert page.has_text?("Username: #{un}")
    assert page.has_text?("Email: #{e}")
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def check_own_page(u)
    login_as(u, scope: :user)
    check_profile_enabled(u)

    # Can access profile page from menu bar
    visit root_path
    assert page.has_link?('Your Profile', href: user_path(u))
  end

  test 'unregistered visitors may not view user profile pages' do
    check_profile_disabled(@u1)
    check_profile_disabled(@u2)
    check_profile_disabled(@u3)
    check_profile_disabled(@u4)
    check_profile_disabled(@u5)
    check_profile_disabled(@u6)
    check_profile_disabled(@u7)
  end

  test 'user may not view profiles of other users' do
    user_view_other_profile(@u1, @u2)
    user_view_other_profile(@u1, @u3)
    user_view_other_profile(@u1, @u4)
    user_view_other_profile(@u1, @u5)
    user_view_other_profile(@u1, @u6)
    user_view_other_profile(@u1, @u7)
  end

  test 'users can view their own profiles' do
    check_own_page(@u1)
    check_own_page(@u2)
    check_own_page(@u3)
    check_own_page(@u4)
    check_own_page(@u5)
    check_own_page(@u6)
    check_own_page(@u7)
  end

  test 'regular admin can view user profiles' do
    login_as(@a4, scope: :admin)
    check_profile_enabled(@u1)
    check_profile_enabled(@u2)
    check_profile_enabled(@u3)
    check_profile_enabled(@u4)
    check_profile_enabled(@u5)
    check_profile_enabled(@u6)
    check_profile_enabled(@u7)
  end

  test 'super admin can view user profile' do
    login_as(@a1, scope: :admin)
    check_profile_enabled(@u1)
    check_profile_enabled(@u2)
    check_profile_enabled(@u3)
    check_profile_enabled(@u4)
    check_profile_enabled(@u5)
    check_profile_enabled(@u6)
    check_profile_enabled(@u7)
  end
end
