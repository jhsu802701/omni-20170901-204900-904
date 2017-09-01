# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  last_name              :string
#  first_name             :string
#  username               :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(last_name: 'Bond', first_name: 'James',
                     username: 'jbond007', email: '007@example.com',
                     password: 'bond_james_bond',
                     password_confirmation: 'bond_james_bond',
                     confirmed_at: Time.now)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'email should be present' do
    @user.email = '     '
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
    @user.email = 'a' * 243 + '@example.com'
    assert @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email address should be unique' do
    # duplicate_user: same email but uppercase; different username
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    duplicate_user.username = 'jbond008'
    @user.save
    assert_not duplicate_user.valid?
    # duplicate_user: different email; different username
    duplicate_user = @user.dup
    duplicate_user.email = '008@example.com'
    duplicate_user.username = 'jbond008'
    @user.save
    assert duplicate_user.valid?
  end

  test 'username should be unique' do
    # duplicate_user: different email; same username but uppercase
    duplicate_user = @user.dup
    duplicate_user.email = '008@example.com'
    duplicate_user.username = @user.username.upcase
    @user.save
    assert_not duplicate_user.valid?
    # duplicate_user: different email; different username
    duplicate_user = @user.dup
    duplicate_user.email = '008@example.com'
    duplicate_user.username = 'jbond008'
    @user.save
    assert duplicate_user.valid?
  end

  test 'username should be present' do
    @user.username = 'jbond_007'
    assert @user.valid?
    @user.username = 'j'
    assert @user.valid?
    @user.username = '     '
    assert_not @user.valid?
  end

  test 'username should not have @ symbol in it' do
    @user.username = 'jbond007@'
    assert_not @user.valid?
    @user.username = '@jbond007'
    assert_not @user.valid?
    @user.username = 'jbond007@example.com'
    assert_not @user.valid?
  end

  test 'username should be no longer than 255 characters' do
    @user.username = 'a' * 256
    assert_not @user.valid?
    @user.username = 'a' * 255
    assert @user.valid?
  end

  test 'first name should be present and no longer than 50 characters' do
    @user.first_name = '     '
    assert_not @user.valid?
    @user.first_name = 'A' + 'a' * 50
    assert_not @user.valid?
  end

  test 'last name should be present and no longer than 50 characters' do
    @user.last_name = '     '
    assert_not @user.valid?
    @user.last_name = 'A' + 'a' * 50
    assert_not @user.valid?
  end

  test 'password should have a minimum length of 10 characters' do
    @user.password = @user.password_confirmation = 'a' * 9
    assert_not @user.valid?
    @user.password = @user.password_confirmation = 'a' * 10
    assert @user.valid?
  end
end
