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

class Application < ActiveRecord::Base

  ## DockerApplication
  include DockerApplication

  ## Relations
  has_many   :members, dependent: :destroy
  has_many   :users,  through: :members, source: :enrolable, source_type: 'User'
  has_many   :groups, through: :members, source: :enrolable, source_type: 'Group'

  belongs_to :application_type
  belongs_to :stage

  has_one    :distant_repo,    dependent: :destroy, class_name: 'ApplicationRepository'
  has_one    :local_repo,      dependent: :destroy, class_name: 'ContainerRepository'
  has_one    :database,        dependent: :destroy, class_name: 'ApplicationDatabase'
  has_one    :ssl_certificate, dependent: :destroy

  has_many   :env_vars,        dependent: :destroy
  has_many   :mount_points,    dependent: :destroy
  has_many   :domain_names,    dependent: :destroy

  has_many   :configs,    dependent: :destroy
  has_many   :pushes,     dependent: :destroy
  has_many   :builds,     dependent: :destroy
  has_many   :releases,   dependent: :destroy
  has_many   :containers, dependent: :destroy

  # Associations helper methods
  has_many   :domain_aliases,   -> { where(mode: 'alias') },    class_name: 'DomainName'
  has_many   :domain_redirects, -> { where(mode: 'redirect') }, class_name: 'DomainName'

  accepts_nested_attributes_for :database
  accepts_nested_attributes_for :env_vars,     allow_destroy: true
  accepts_nested_attributes_for :mount_points, allow_destroy: true
  accepts_nested_attributes_for :domain_names, allow_destroy: true

  ## Basic Validations
  validates :domain_name, presence: true, on: :update
  validates :instance_number, presence: true, inclusion: { in: (1..DeployIt::MAX_INSTANCES_NUMBER).to_a }

  ## Scopes
  scope :visible, lambda { |*args| where(Application.visible_condition(args.shift || User.current, *args)) }
  scope :sorted_by_identifier, -> { order(:identifier) }

  ## Delegations to Stage
  delegate :platform, to: :stage

  ## Virtual attribute
  attr_accessor :domain_name_has_changed

  ## Callbacks
  after_save  :check_if_domain_name_changed

  ## UseCases
  add_use_cases [ :build, :start, :stop, :restart, :pause, :unpause ], prefix: '::Docker'
  add_use_cases [ :create_physical_database, :destroy_physical_database ], prefix: '::Database'
  add_use_cases [ :create_lb_route, :destroy_lb_route ], prefix: '::Router'
  add_use_cases [ :get_default_params, :restore_env_vars, :restore_mount_points, :create_relations ], prefix: '::Params'
  add_use_cases [ :bootstrap, :update_files, :destroy_forever ], prefix: '::Files'

  ## AsyncModels
  acts_as_async_model


  class << self

    def max_instances_number
      (1..DeployIt::MAX_INSTANCES_NUMBER).to_a
    end

    def find_by_deploy_url(deploy_url)
      super sanitize(deploy_url)
    end

    def sanitize(deploy_url)
      deploy_url.start_with?('/') ? deploy_url[1..-1] : deploy_url
    end

  end


  def to_s
    fullname
  end


  def fullname
    "#{name} - #{stage.name}"
  end


  def fullname_with_dashes
    "#{identifier}-#{stage.identifier}"
  end


  def config_id
    deploy_url.gsub('/', '_')
  end


  def type
    application_type
  end


  def stage_identifier
    stage.identifier
  end


  def push_url
    local_repo.git_url
  end


  def people_to_notify
    calculated_members
  end


  def notification_channels
    people_to_notify.map(&:pusher_token)
  end


  def domain_name_has_changed?
    domain_name_has_changed
  end


  def create_build_request!(push, user = User.current)
    builds.create(
      author_id:  user.id,
      push_id:    push.id,
      request_id: SecureRandom.uuid,
      state:      'new'
    )
  end


  def create_new_release!(opts = nil)
    opts = default_build_refs if opts.nil?
    releases.create(opts)
  end


  def default_build_refs
    {
      ref_name:     distant_repo.local_branch,
      old_revision: distant_repo.last_commit(false),
      new_revision: distant_repo.last_commit(false),
      author:       User.current
    }
  end


  private


    # This is Rails method : <attribute>_changed?
    # However, the value is cleared before passing the object to the controller.
    # We need to save it in virtual attribute to trigger Repository reclone if changed.
    #
    def check_if_domain_name_changed
      if domain_name_changed?
        self.domain_name_has_changed = true
      else
        self.domain_name_has_changed = false
      end
    end

end
