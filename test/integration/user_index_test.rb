require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
  def check_index_disabled
    visit users_path
    assert page.has_css?('title', text: full_title(''),
                                  visible: false)
    assert page.has_css?('h1', text: 'Home', visible: false)
  end

  def check_index_disabled_for_user(u)
    login_as(u, scope: :user)
    check_index_disabled
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def check_index_enabled
    visit users_path
    assert page.has_css?('title', text: full_title('User Index'),
                                  visible: false)
    assert page.has_css?('h1', text: 'User Index')
    assert page.has_text?('Connery')
    assert page.has_text?('Lazenby')
    assert page.has_text?('Moore')
    assert page.has_text?('Dalton')
    assert page.has_text?('Brosnan')
    assert page.has_text?('Craig')
    assert page.has_text?('Blofeld')

    # Verify that index page provides access to profile pages
    assert page.has_link?('sconnery', href: user_path(@u1))
    assert page.has_link?('sean_connery@example.com', href: user_path(@u1))
    assert page.has_link?('glazenby', href: user_path(@u2))
    assert page.has_link?('george_lazenby@example.com', href: user_path(@u2))
    assert page.has_link?('rmoore', href: user_path(@u3))
    assert page.has_link?('roger_moore@example.com', href: user_path(@u3))
    assert page.has_link?('tdalton', href: user_path(@u4))
    assert page.has_link?('timothy_dalton@example.com', href: user_path(@u4))
    assert page.has_link?('pbrosnan', href: user_path(@u5))
    assert page.has_link?('pierce_brosnan@example.com', href: user_path(@u5))
    assert page.has_link?('dcraig', href: user_path(@u6))
    assert page.has_link?('daniel_craig@example.com', href: user_path(@u6))
    assert page.has_link?('eblofeld', href: user_path(@u7))
    assert page.has_link?('ernst_blofeld@example.com', href: user_path(@u7))

    # Verify that root page provides access to index page
    click_on 'Home'
    assert page.has_link?('User Index', href: users_path)
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  test 'users index page is not accessible to visitors' do
    check_index_disabled
  end

  test 'users index page is not accessible to users' do
    check_index_disabled_for_user(@u1)
    check_index_disabled_for_user(@u2)
    check_index_disabled_for_user(@u3)
    check_index_disabled_for_user(@u4)
    check_index_disabled_for_user(@u5)
    check_index_disabled_for_user(@u6)
    check_index_disabled_for_user(@u7)
  end

  test 'users index page is accessible to super admins' do
    login_as(@a1, scope: :admin)
    check_index_enabled
  end

  test 'users index page is accessible to regular admins' do
    login_as(@a4, scope: :admin)
    check_index_enabled
  end
end
