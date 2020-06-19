# frozen_string_literal: true
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

class Container < ApplicationRecord

  # Disable STI for this class
  self.inheritance_column = 'types'

  ## DockerContainer
  include ActsAs::DockerContainer

  include ActiveUseCase::Model

  ## Relations
  belongs_to :application
  belongs_to :docker_server, foreign_key: 'server_id', class_name: 'Server'
  belongs_to :release
  has_many   :events, class_name: 'ContainerEvent', dependent: :destroy

  ## Basic Validations
  validates :application_id, presence: true
  validates :server_id,      presence: true
  validates :release_id,     presence: true
  validates :type,           presence: true, inclusion: { in: CONTAINER_TYPES_AVAILABLE }
  validates :image_name,     presence: true

  ## Scopes
  scope :to_delete,  -> { where(marked_for_deletion: true) }

  CONTAINER_TYPES_AVAILABLE.each do |type|
    scope_name = "type_#{type}".to_sym
    scope scope_name, -> { where(type: type) }
  end

  ## UseCases
  add_use_cases [:deploy, :start, :stop, :restart, :pause, :unpause, :destroy_forever]

  ## AsyncModels
  acts_as_async_model 'Container'


  def to_s
    return '' if docker_id.nil?
    docker_name
  end


  def short_id
    return '' if docker_id.nil?
    docker_id[0..12]
  end


  def stype
    type.to_sym
  end


  def notification_channels
    application.notification_channels
  end


  def current_revision
    release.revision[0..12]
  end


  def mark_for_deletion!
    update_attribute(:marked_for_deletion, true)
  end


  def unmark_for_deletion!
    update_attribute(:marked_for_deletion, false)
  end


  def infected?
    events.unknow_process.not_seen.any?
  end

end
