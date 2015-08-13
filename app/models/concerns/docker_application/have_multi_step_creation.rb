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

module DockerApplication
  module HaveMultiStepCreation
    extend ActiveSupport::Concern

    VALID_REPO_REGEX = /\A(ssh:\/\/)([\w\-\.@]+)(\:[\d]+)?([\w\/\-\.~]+)(\.git)?\z/i

    included do
      ## First step
      validates :name,                presence: true, if: lambda { |o| o.first_step_or_last_step? }
      validates :identifier,          presence: true, if: lambda { |o| o.first_step_or_last_step? }, length: { maximum: 13 }, exclusion: { in: lambda { |o| ReservedName.all.map(&:name) } }
      validates :application_type_id, presence: true, if: lambda { |o| o.first_step_or_last_step? }
      validates :stage_id,            presence: true, if: lambda { |o| o.first_step_or_last_step? }, uniqueness: { case_sensitive: false, scope: :identifier }

      ## Second step
      validates :deploy_url,     presence: true,    if: lambda { |o| o.second_step_or_last_step? }
      validates :domain_name,    presence: true,    if: lambda { |o| o.second_step_or_last_step? }
      validates :repository_url, presence: true,    if: lambda { |o| o.second_step_or_last_step? }, format: { with: VALID_REPO_REGEX }
      validates :temp_db_name,   presence: true,    if: lambda { |o| o.second_step_or_last_step? }
      validates :temp_db_user,   presence: true,    if: lambda { |o| o.second_step_or_last_step? }
      validates :temp_db_type,   presence: true,    if: lambda { |o| o.second_step_or_last_step? }, inclusion: { in: DeployIt::AVAILABLE_DATABASES }
      validates :image_type,     presence: true,    if: lambda { |o| o.second_step_or_last_step? }, inclusion: { in: lambda { |o| DockerImage.all.map(&:name) } }
      validates :buildpack,      allow_blank: true, if: lambda { |o| o.second_step_or_last_step? }, inclusion: { in: lambda { |o| Buildpack.all.map(&:url) } }

      ## Callbacks
      before_validation { self.identifier = identifier.downcase if !identifier.nil? }

      after_validation :add_deploy_url_field,  if: lambda { |o| o.first_step? }
      after_validation :add_database_fields,   if: lambda { |o| o.first_step? }
      after_validation :add_domain_name_field, if: lambda { |o| o.first_step? }

      before_validation :add_deploy_url_field,  if: lambda { |o| o.second_step_or_last_step? }
      before_validation :add_database_fields,   if: lambda { |o| o.second_step_or_last_step? }
      before_validation :add_repo_branch_field, if: lambda { |o| o.second_step_or_last_step? }
    end


    attr_writer :current_step

    attr_accessor :temp_db_type
    attr_accessor :temp_db_name
    attr_accessor :temp_db_user
    attr_accessor :temp_db_pass

    attr_accessor :repository_url
    attr_accessor :repository_branch


    def steps
      %w[ select_params select_params2 submit_form ]
    end


    def current_step
      @current_step
    end


    def current_index
      steps.index(current_step)
    end


    def total_steps
      steps.length
    end


    def step_forward
      self.current_step = steps[steps.index(current_step) + 1]
    end


    def step_back
      self.current_step = steps[steps.index(current_step) - 1]
    end


    def first_step?
      current_step == steps.first
    end


    def second_step?
      current_step == 'select_params2'
    end


    def last_step?
      current_step == steps.last
    end


    def first_step_or_last_step?
      first_step? || last_step?
    end


    def second_step_or_last_step?
      second_step? || last_step?
    end


    def current_step_valid?
      valid?
    end


    def all_steps_valid?
      steps.all? do |step|
        self.current_step = step
        valid?
      end
    end


    private


      def add_deploy_url_field
        return if stage.nil?
        self.deploy_url = "#{stage.platform.identifier}/#{stage.identifier}/#{identifier}"
      end


      def add_database_fields
        return if stage.nil?
        self.temp_db_name = set_field(identifier, stage.database_name_prefix)
        self.temp_db_user = set_field(identifier, stage.database_name_prefix)
        self.temp_db_pass = DeployIt::Utils::Crypto.generate_secret(12)
      end


      def add_domain_name_field
        return if stage.nil?
        domain = "#{identifier}.#{stage.domain_name_suffix}"
        self.domain_name = domain if field_empty?(:domain_name)
      end


      def set_field(identifier, prefix = '')
        sanitize("#{prefix}#{identifier}")
      end


      def sanitize(content)
        content.gsub(/[\-]/, '_')
      end


      def add_repo_branch_field
        branch = (!repository_branch.nil? && !repository_branch.blank?) ? repository_branch : 'master'
        self.repository_branch = branch if field_empty?(:repository_branch)
      end


      def field_empty?(field)
        self.send(field).nil? || self.send(field).empty?
      end

  end
end
