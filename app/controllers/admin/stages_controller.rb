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

class Admin::StagesController < Admin::DefaultController

  before_action :set_platform
  before_action :set_stage, only: [:show, :edit, :update, :destroy]


  def index
    render_404
  end


  def show
    render_404
  end


  def new
    @stage = @platform.stages.new
    add_crumb t('.title'), '#'
  end


  def edit
    add_crumb @stage.name, '#'
  end


  def create
    @stage = @platform.stages.new(stage_params)

    if @stage.save
      flash[:notice] = t('.notice')
      redirect_to admin_platforms_path
    else
      add_crumb t('label.stage.new'), '#'
      render :new
    end
  end


  def update
    if @stage.update(stage_params)
      flash[:notice] = t('.notice')
      redirect_to admin_platforms_path
    else
      render :edit
    end
  end


  def destroy
    if @stage.destroy
      flash[:notice] = t('.notice')
    else
      flash[:alert] = @stage.errors.full_messages
    end
    redirect_to admin_platforms_path
  end


  private


    def set_platform
      @platform = Platform.find(params[:platform_id])
      add_crumb label_with_icon(Platform.model_name.human(count: 2), 'fa-sitemap', fixed: true), admin_platforms_path
      add_crumb @platform.name, admin_platforms_path
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def set_stage
      @stage = @platform.stages.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def stage_params
      params.require(:stage).permit(:name, :identifier, :portal_url, :database_name_prefix, :domain_name_suffix, :description)
    end

end
