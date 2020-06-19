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

class StagePresenter < SimpleDelegator

  attr_reader :stage


  def initialize(stage, template)
    super(template)
    @stage = stage
  end


  def edit_link
    link_to stage.name, edit_admin_platform_stage_path(stage.platform, stage)
  end


  def stage_infos
    content_tag(:p, stage_identifier.html_safe) +
    content_tag(:p, database_name_prefix.html_safe) +
    content_tag(:p, domain_name_suffix.html_safe)
  end


  private


    def stage_identifier
      "#{Stage.human_attribute_name('identifier')} : #{tagged_data(stage.identifier)}"
    end


    def database_name_prefix
      "#{Stage.human_attribute_name('database_name_prefix')} : #{tagged_data(stage.database_name_prefix)}"
    end


    def domain_name_suffix
      "#{Stage.human_attribute_name('domain_name_suffix')} : #{tagged_data(stage.domain_name_suffix)}"
    end


    def tagged_data(data)
      return '-' if data.empty?
      label_with_primary_tag(data)
    end

end
