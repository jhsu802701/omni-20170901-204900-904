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

#
class User < ApplicationRecord
  # Limit the parameters available for searching the user database
  RANSACKABLE_ATTRIBUTES = %w[email username last_name first_name].freeze
  def self.ransackable_attributes(_auth_object = nil)
    RANSACKABLE_ATTRIBUTES + _ransackers.keys
  end

  # Specify the number of entries per page given use of the will_paginate gem
  self.per_page = 50

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    # rubocop:disable Lint/AssignmentInCondition
    if login = conditions.delete(:login)
      # rubocop:disable Metrics/LineLength
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
      # rubocop:enable Metrics/LineLength
    elsif conditions._key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
    # rubocop:enable Lint/AssignmentInCondition
  end
  # BEGIN: public section
  # BEGIN: devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
  # END: devise modules

  before_save :downcase_email, :downcase_username

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, presence: true, length: { maximum: 50 }

  VALID_USERNAME_REGEX = /\A[\w+\-.]+\z/i
  validates :username, presence: true, length: { maximum: 255 },
                       format: { with: VALID_USERNAME_REGEX },
                       uniqueness: { case_sensitive: false }
  # END: public section

  private

  # BEGIN: private section
  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  # Converts username to all lower-case.
  def downcase_username
    self.username = username.downcase
  end
  # END: private section
end
