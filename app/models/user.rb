# DeployIt - Docker containers management software
# Copyright (C) 2015 Nicolas Rodriguez (nrodriguez@jbox-web.com), JBox Web (http://www.jbox-web.com)
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License, version 3,
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License, version 3,
# along with this program.  If not, see <http://www.gnu.org/licenses/>

require 'digest'

class User < ActiveRecord::Base

  ## Module copied from Redmine to perform Authorization
  include Authorizable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  ## Relations
  has_many :ssh_public_keys
  has_and_belongs_to_many :groups

  has_many :memberships, as: :enrolable, class_name: 'Member', dependent: :destroy
  has_many :applications, through: :memberships

  ## Basic Validations
  validates :email,     presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname,  presence: true, length: { maximum: 50 }
  validates :language,  presence: true
  validates :time_zone, presence: true, inclusion: { in: ActiveSupport::TimeZone.zones_map(&:name).keys }

  validates :password,  presence: true, length: { minimum: 6 }, on: :create
  validates_confirmation_of :password, on: :create

  validates :api_token,            presence: true
  validates :authentication_token, presence: true

  ## Callbacks
  before_validation { self.email = email.downcase if !email.nil? }
  before_validation :ensure_api_token
  before_validation :ensure_authentication_token

  ## Scopes
  scope :by_email,  -> { order(email: :asc) }
  scope :admin,     -> { where(admin: true) }
  scope :non_admin, -> { where(admin: false) }
  scope :active,    -> { where(enabled: true) }
  scope :locked,    -> { where(enabled: false) }


  class << self

    def current=(user)
      RequestStore.store[:current_user] = user
    end

    def current
      RequestStore.store[:current_user] ||= User.anonymous
    end

    # Returns the anonymous user.
    def anonymous
      AnonymousUser.new(firstname: 'Anonymous', lastname: '', email: '',)
    end

  end


  def to_s
    full_name
  end


  def logged?
    true
  end


  def anonymous?
    !logged?
  end


  def last_connection
    last_sign_in_at ? I18n.l(last_sign_in_at) : User.human_attribute_name('never_connected')
  end


  def full_name
    "#{firstname} #{lastname}"
  end


  def notification_token
    @sha256 ||= Digest::SHA256.new.hexdigest(email)
  end


  def private_channel
    "/private/#{notification_token}"
  end


  def active_for_authentication?
    enabled?
  end


  def inactive_message
    enabled? ? super : User.human_attribute_name('disabled')
  end


  def disabled?
    !enabled?
  end


  def subscribed_channels
    AsyncNotifications.channels.map(&:name)
  end


  private


    def ensure_api_token
      self.api_token = generate_token_for(:api_token) if api_token.blank?
    end


    def ensure_authentication_token
      self.authentication_token = generate_token_for(:authentication_token) if authentication_token.blank?
    end


    def generate_token_for(field, size = 42)
      loop do
        token = DeployIt::Utils::Crypto.generate_secret(size)
        break token unless User.where(field => token).first
      end
    end

end
