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

  include BelongsToPlatform

  before_action :set_stage, only: [:show, :edit, :update, :destroy]


  def new
    @stage = @platform.stages.new
    add_breadcrumbs(@stage)
  end


  def edit
    add_breadcrumbs(@stage)
  end


  def create
    @stage = @platform.stages.new(stage_params)
    if @stage.save
      render_success
    else
      add_breadcrumbs(@stage)
      render :new
    end
  end


  def update
    if @stage.update(stage_params)
      render_success
    else
      add_breadcrumbs(@stage)
      render :edit
    end
  end


  def destroy
    @stage.destroy ? render_success : render_failed(@stage)
  end


  private


    def set_stage
      @stage = @platform.stages.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def stage_params
      params.require(:stage).permit(:name, :identifier, :portal_url, :database_name_prefix, :domain_name_suffix, :description)
    end

end
