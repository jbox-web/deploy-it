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

  add_crumb label_with_icon(User.model_name.human(count: 2), 'fa-user', fixed: true),
            only: [:show, :new, :edit, :change_password] { |instance| instance.send :admin_users_path }


  def index
    @users = User.by_email
  end


  def show
    render_404
  end


  def new
    @user = User.new
    @user_form = UserCreationForm.new(@user)

    add_crumb t('.title'), '#'
  end


  def edit
    add_crumb @user.full_name, '#'
    add_crumb t('text.edit'), '#'
  end


  def create
    @user = User.new
    @user_form = UserCreationForm.new(@user)
    @user_form.submit(user_create_params)

    if @user_form.save
      flash[:notice] = t('.notice')
      redirect_to admin_users_path
    else
      add_crumb label_with_icon(User.model_name.human(count: 2), 'fa-user', fixed: true), admin_users_path
      add_crumb t('.title'), '#'

      render :new
    end
  end


  def update
    if @user.update(user_update_params)
      # Locales may have changed, reset them before redirect
      reload_user_locales if @user.id == User.current.id
      flash[:notice] = t('.notice')
      # Call service objects to perform other actions
      call_service_objects
      redirect_to admin_users_path
    else
      add_crumb label_with_icon(User.model_name.human(count: 2), 'fa-user', fixed: true), admin_users_path
      add_crumb @user.full_name, '#'
      add_crumb t('.title'), '#'

      render :edit
    end
  end


  def destroy
    if @user.destroy
      flash[:notice] = t('.notice')
      redirect_to admin_users_path
    else
      flash[:alert] = @user.errors.full_messages
      redirect_to admin_users_path
    end
  end


  def change_password
    add_crumb @user.full_name, edit_admin_user_path(@user)
    add_crumb t('.changing_password'), '#'

    @password_form = AdminPasswordForm.new(@user)
    if request.patch?
      @password_form.submit(user_change_password_params)
      if @password_form.save
        sign_in(@user, bypass: true) if @user.id == User.current.id
        redirect_to admin_users_path, notice: t('.notice')
      end
    end
  end


  def create_membership
    if !membership_create_params[:application_id].blank?
      application = Application.find(membership_create_params[:application_id])
      @member = Member.new(role_ids: membership_create_params[:role_ids], enrolable_type: 'User',  enrolable_id: @user.id)
      application.members << @member
    end
    respond_to do |format|
      format.js { render 'admin/users/ajax/create_membership' }
    end
  end


  def update_membership
    @member = Member.find(params[:membership_id])
    @member.role_ids = membership_update_params[:role_ids]
    @member.save
    respond_to do |format|
      format.js { render 'admin/users/ajax/update_membership' }
    end
  end


  def destroy_membership
    @member = Member.find(params[:membership_id])
    @member.destroy if request.delete? && @member.deletable?
    respond_to do |format|
      format.js { render 'admin/users/ajax/destroy_membership' }
    end
  end


  private


    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


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


    def membership_create_params
      params.require(:membership).permit(:application_id, role_ids: [])
    end


    def membership_update_params
      params.require(:membership).permit(role_ids: [])
    end


    def call_service_objects
      results = []
      case self.action_name
      when 'update'
        if @user.disabled?
          # @user.ssh_public_keys.each do |ssh_key|
          #   result = DestroySshKey.new(ssh_key).call
          #   results = results.concat(result.errors) if !result.success?
          # end
        else
          # @user.ssh_public_keys.each do |ssh_key|
          #   result = CreateSshKey.new(ssh_key).call
          #   results = results.concat(result.errors) if !result.success?
          # end
        end
      end
      # flash[:alert] = results
    end

end
