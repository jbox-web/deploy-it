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

class Repository < ApplicationRecord

  ## Rugged methods (exits?, empty? ...)
  include ActsAs::RuggedRepository

  GIT_USER_REGEX = /\A(ssh:\/\/)?([a-z\-]+)@([a-z0-9\.\-]+):?([0-9]+)?:?([a-z0-9\-\/]+\.git)\z/i

  ## Relations
  belongs_to :application
  belongs_to :credential, class_name: 'RepositoryCredential'

  ## Basic Validations
  validates :relative_path, presence: true
  validates :type,          uniqueness: { scope: :application_id }
  validates :credential_id, presence: true, if: :have_credentials?

  ## Callbacks
  before_save :reset_credential_id
  after_save  :check_if_url_changed
  after_save  :check_if_branch_changed

  ## UseCases
  add_use_cases [ :init_bare, :clone, :resync, :create_archive, :destroy_forever ]

  ## AsyncModels
  acts_as_async_model 'Repository'

  # Virtual attribute
  attr_accessor :url_has_changed
  attr_accessor :branch_has_changed


  def to_s
    name
  end


  def name
    application.fullname
  end


  def notification_channels
    application.notification_channels
  end


  def url_has_changed?
    url_has_changed
  end


  def branch_has_changed?
    branch_has_changed
  end


  def username
    url.match(GIT_USER_REGEX)[2]
  end


  def exists?
    Dir.exists?(path)
  end


  def destroy_dir!
    FileUtils.rm_rf(path)
  end


  private


    def reset_credential_id
      self.credential_id = nil if !have_credentials
    end


    # This is Rails method : <attribute>_changed?
    # However, the value is cleared before passing the object to the controller.
    # We need to save it in virtual attribute to trigger Repository reclone if changed.
    #
    def check_if_url_changed
      if url_changed?
        self.url_has_changed = true
      else
        self.url_has_changed = false
      end
    end


    def check_if_branch_changed
      if branch_changed?
        self.branch_has_changed = true
      else
        self.branch_has_changed = false
      end
    end

end
