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

class Admin::UsersController < Admin::DCIController

  set_dci_role 'DCI::Roles::AccountManager'

  before_action :set_user,        except: [:index, :new, :create]
  before_action :add_breadcrumbs, except: [:show]


  def index
    @users = User.includes(:ssh_public_keys).by_email
  end


  def show
    render_404
  end


  def new
    render locals: { user: UserCreationForm.new(User.new) }
  end


  def edit
  end


  def create
    set_dci_data({ user: [:firstname, :lastname, :email, :language, :time_zone, :admin, :enabled, :password, :password_confirmation, :create_options, :send_by_mail] })
    call_dci_role(:create_user)
  end


  def update
    set_dci_data({ user: [:firstname, :lastname, :email, :language, :time_zone, :admin, :enabled] })
    call_dci_role(:update_user, @user) do
      reload_user_locales if @user.id == User.current.id
    end
  end


  def destroy
    call_dci_role(:delete_user, @user) if request.delete?
  end


  def change_password
    if request.patch?
      set_dci_data({ user: [:new_password, :new_password_confirmation, :send_by_mail, :create_options] })
      call_dci_role(:change_password, @user) do
        sign_in(@user, bypass: true) if @user.id == User.current.id
      end
    else
      render locals: { password_form: AdminPasswordForm.new(@user) }
    end
  end


  private


    def add_breadcrumbs(action: action_name)
      global_crumbs

      case action
      when 'new', 'create'
        add_crumb t('.title'), '#'
      when 'edit', 'update'
        add_crumb @user.full_name, '#'
        add_crumb t('text.edit'), '#'
      when 'change_password'
        add_crumb @user.full_name, edit_admin_user_path(@user)
        add_crumb t('.changing_password'), '#'
      end
    end


    def global_crumbs
      add_breadcrumb User.model_name.human(count: 2), 'fa-user', admin_users_path
    end


    def render_dci_response(template:, type:, locals: {}, &block)
      if destroy_action? || success_create?(type) || success_update?(type) || success_password_update?(type)
        super { redirect_to admin_users_path }
      else
        super
      end
    end

end
