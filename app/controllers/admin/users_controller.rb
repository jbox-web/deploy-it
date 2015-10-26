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

class Admin::UsersController < Admin::DefaultController

  before_action :set_user, except: [:index, :new, :create]


  def index
    @users = User.by_email
  end


  def show
    render_404
  end


  def new
    @user = User.new
    @user_form = UserCreationForm.new(@user)
    add_breadcrumbs
  end


  def edit
    add_breadcrumbs
  end


  def create
    @user = User.new
    @user_form = UserCreationForm.new(@user)
    @user_form.submit(user_create_params)

    if @user_form.save
      render_success
    else
      add_breadcrumbs
      render :new
    end
  end


  def update
    if @user.update(user_update_params)
      # Locales may have changed, reset them before redirect
      reload_user_locales if @user.id == User.current.id
      # Call service objects to perform other actions
      call_service_objects
      render_success
    else
      add_breadcrumbs
      render :edit
    end
  end


  def destroy
    execute_action(:remove_from_authorized_keys!)
    @user.destroy ? render_success : render_failed
  end


  def change_password
    add_breadcrumbs
    @password_form = AdminPasswordForm.new(@user)
    if request.patch?
      @password_form.submit(user_change_password_params)
      if @password_form.save
        sign_in(@user, bypass: true) if @user.id == User.current.id
        render_success
      end
    end
  end


  private


    def user_create_params
      params.require(:user).permit(:firstname, :lastname, :email, :language, :time_zone, :admin, :enabled,
        :password, :password_confirmation, :create_options, :send_by_mail)
    end


    def user_update_params
      params.require(:user).permit(:firstname, :lastname, :email, :language, :time_zone, :admin, :enabled)
    end


    def user_change_password_params
      params.require(:user).permit(:new_password, :new_password_confirmation, :send_by_mail, :create_options)
    end


    def render_success
      redirect_to admin_users_path, notice: t('.notice')
    end


    def render_failed
      redirect_to admin_users_path, alert: @user.errors.full_messages
    end


    def call_service_objects
      errors = @user.disabled? ? execute_action(:remove_from_authorized_keys!) : execute_action(:add_to_authorized_keys!)
      flash[:alert] = errors if !errors.empty?
    end


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
      add_crumb label_with_icon(User.model_name.human(count: 2), 'fa-user', fixed: true), admin_users_path
    end


    def execute_action(method)
      errors = []
      @user.ssh_public_keys.each do |ssh_key|
        result = ssh_key.send(method)
        errors += result.errors if !result.success?
      end
      errors
    end

end
