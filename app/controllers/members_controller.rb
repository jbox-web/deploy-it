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

  before_action :set_application
  before_action :authorize

  before_action :set_member, only: [:update, :destroy]


  def create
    members = []
    members += build_members('User', member_params[:user_ids], member_params[:role_ids])
    members += build_members('Group', member_params[:group_ids], member_params[:role_ids])
    @application.members << members
    @member_ids = members.map(&:id)
  end


  def update
    @member.role_ids = member_params[:role_ids]
    @member.save
  end


  def destroy
    @member.destroy if request.delete? && @member.deletable?
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


    def build_members(type, list_ids = [], role_ids = [])
      list_ids.select { |id| !id.empty? }.map{ |id| build_member(id, type, role_ids) }
    end


    def build_member(id, type, role_ids = [])
      Member.new(enrolable_id: id, enrolable_type: type, role_ids: role_ids)
    end

end
