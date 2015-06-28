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

class MembersController < ApplicationController

  before_action :require_login
  before_action :set_application
  before_action :authorize

  before_action :set_member, only: [ :update, :destroy ]


  def create
    members = []

    member_params[:user_ids].each do |user_id|
      next if user_id == ''
      members << Member.new(role_ids: member_params[:role_ids], enrolable_type: 'User',  enrolable_id: user_id)
    end

    member_params[:group_ids].each do |group_id|
      next if group_id == ''
      members << Member.new(role_ids: member_params[:role_ids], enrolable_type: 'Group',  enrolable_id: group_id)
    end

    @application.members << members

    @member_ids = members.map(&:id)
  end


  def update
    @member.role_ids = member_params[:role_ids]
    @member.save
  end


  def destroy
    if request.delete? && @member.deletable?
      @member.destroy
    end
  end


  private


    def set_application
      @application = Application.find(params[:application_id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def set_member
      @member = Member.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render_404
    end


    def member_params
      params.require(:member).permit(user_ids: [], group_ids: [], role_ids: [])
    end

end
