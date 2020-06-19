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

class AdminPasswordForm < ActionForm::Base

  self.main_model = :user

  ## Virtual attributes : needed to update current password
  attr_accessor :new_password

  ## Virtual attributes (options)
  attr_accessor :create_options
  attr_accessor :send_by_mail

  ## Validations
  validates :create_options,  presence: true, inclusion: { in: [ 'generate', 'manual' ] }
  validates :new_password,    presence: true, length: { minimum: 6 }
  validates_confirmation_of :new_password


  def user
    @model
  end


  ## Override inherited method to assign virtual attributes (attr_accessor).
  ## (kind of alias_method_chain)
  def submit(params)
    super

    if create_options == 'generate'
      generated_password = Devise.friendly_token.first(8)
      self.new_password = generated_password
      self.new_password_confirmation = generated_password
    end

    ## Assign real attributes
    user.password = new_password
    user.password_confirmation = new_password
  end


  def send_email?
    send_by_mail == '1'
  end

end
