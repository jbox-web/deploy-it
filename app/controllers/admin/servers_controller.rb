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

class Admin::ServersController < Admin::DefaultController

  before_action :set_platform
  before_action :set_server, except: [:index, :new, :create]
  before_action :find_jbox_role_module, only: [:enable_role, :disable_role]
  before_action :find_server_role,      only: [:status]


  def index
    render_404
  end


  def show
    render_404
  end


  def new
    @server = @platform.servers.new
    add_crumb t('.title'), '#'
  end


  def edit
    add_crumb @server.host_name, '#'
  end


  def create
    @server = @platform.servers.new(server_params)

    if @server.save
      flash[:notice] = t('.notice')
      redirect_to admin_platforms_path
    else
      add_crumb t('.title'), '#'
      render :new
    end
  end


  def update
    flash[:notice] = t('.notice') if @server.update(server_params)
    render_ajax_response
  end


  def destroy
    if @server.destroy
      flash[:notice] = t('.notice')
    else
      flash[:alert] = @server.errors.full_messages
    end
    redirect_to admin_platforms_path
  end


  def status
    result = @server.get_service_status(@server_role)
    if result.success?
      @errors = false
    else
      @errors = true
      flash[:alert] = result.errors
    end
    render_ajax_response
  end


  def enable_role
    if !@server.has_role?(@jbox_role_module.type)
      opts = { name: @jbox_role_module.type, platform: @server.platform }.merge(@jbox_role_module.default_options)
      @server.roles.create(opts)
      flash[:notice] = t('.notice', role: @jbox_role_module.to_s)
    end
    render_ajax_response('toggle_role')
  end


  def disable_role
    if @server.has_role?(@jbox_role_module.type)
      @server.roles.find_by_name(@jbox_role_module.type).destroy!
      @server.reload
      flash[:notice] = t('.notice', role: @jbox_role_module.to_s)
    end
    render_ajax_response('toggle_role')
  end


  def update_roles
    flash[:notice] = t('.notice') if @server.update(roles_params)
    render_ajax_response
  end


  private


    def set_platform
      @platform = Platform.find(params[:platform_id])
      add_crumb label_with_icon(Platform.model_name.human(count: 2), 'fa-sitemap', fixed: true), admin_platforms_path
      add_crumb @platform.name, admin_platforms_path
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def set_server
      @server = @platform.servers.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def find_jbox_role_module
      @jbox_role_module = ServerRole.find_jbox_role_module(params[:role])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def find_server_role
      @server_role = @server.roles.find_by_name(params[:role])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def server_params
      params.require(:server).permit(:host_name, :ip_address, :ssh_user, :ssh_port, :description)
    end


    def roles_params
      params.require(:server).permit(roles_attributes: [:id, :default_server, :alternative_host, :port, :connection_timeout])
    end

end
