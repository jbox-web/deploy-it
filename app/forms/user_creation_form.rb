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

class UserCreationForm < ActionForm::Base

  PASSWORD_OPTIONS = [
    ['generate', User.human_attribute_name('generate_password')],
    ['manual',   User.human_attribute_name('specify_password')]
  ]

  self.main_model = :user

  ## Real attributes
  attribute :firstname, required: false
  attribute :lastname,  required: false
  attribute :email,     required: false
  attribute :language,  required: false
  attribute :time_zone, required: false
  attribute :admin,     required: false
  attribute :enabled,   required: false

  attribute :password,              required: false
  attribute :password_confirmation, required: false

  ## Virtual attributes (options)
  attr_accessor :create_options
  attr_accessor :send_by_mail
  attr_accessor :created_password

  ## Validations
  validates :create_options, presence: true, inclusion: { in: ['generate', 'manual'] }


  def user
    @model
  end


  ## Override inherited method to assign hidden attributes.
  ## (kind of alias_method_chain)
  def submit(params)
    super

    if create_options == 'generate'
      self.created_password = Devise.friendly_token.first(8)
      self.password = created_password
      self.password_confirmation = created_password
    else
      self.created_password = params[:password]
    end
  end


  ## Override inherited method to send email.
  ## (kind of alias_method_chain)
  def save
    ## Get saved status from inherited class
    saved = super

    if saved
      send_email if send_email?
    end

    ## Return saved to not break controller
    saved
  end


  private


    def send_email?
      send_by_mail == '1'
    end


    def send_email
      RegistrationMailer.welcome(user, created_password).deliver_now
    end

end
