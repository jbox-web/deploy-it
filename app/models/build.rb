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

class Build < ApplicationRecord

  ## Relations
  belongs_to :application
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :push

  ## Basic Validations
  validates :application_id, presence: true
  validates :author_id,      presence: true
  validates :push_id,        presence: true
  validates :request_id,     presence: true
  validates :state,          presence: true

  ## Delegations
  delegate :ref_name, :old_revision, :new_revision, to: :push

  ## UseCases
  add_use_cases [ :perform_task ]

  ## AsyncModels
  acts_as_async_model

  ## ActsAsStateMachine gem
  include AASM

  ## Declare states and transitions
  aasm column: 'state' do
    state :new, initial: true
    state :pending
    state :running
    state :success
    state :failed
    state :canceled

    event :put_in_stack, after_commit: :get_lock! do
      transitions from: :new, to: :pending, guard: :lock_acquirable?
    end

    event :run do
      transitions from: :pending, to: :running
    end

    event :finish, after_commit: :release_lock! do
      transitions from: :running, to: :success
    end

    event :fail, after_commit: :release_lock! do
      transitions from: :running, to: :failed
    end

    event :cancel do
      transitions from: [:new, :pending], to: :canceled
    end
  end


  def lock_acquirable?
    token = application.deploy_url
    lock  = Lock.find_by_token(token)
    if lock
      errors.add(:base, :cannot_get_lock)
      return false
    else
      return true
    end
  end


  def get_lock!
    token = application.deploy_url
    Lock.create(token: token)
  end


  def release_lock!
    token = application.deploy_url
    lock  = Lock.find_by_token(token)
    lock.destroy if !lock.nil?
  end

end
