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

class JboxRoleModule

  attr_reader :id
  attr_reader :type
  attr_reader :humanize
  attr_reader :name
  attr_reader :service_name
  attr_reader :identifier

  # Availabel server role/module :
  # pg_db
  # mysql_db
  # docker
  # lb
  # log

  def initialize(id)
    @id           = id
    @type         = id
    @humanize     = I18n.t("label.server_role.#{id}")
    @name         = I18n.t("label.server_role.#{id}_role")
    @service_name = I18n.t("label.server_role.#{id}_service")
    @identifier   = get_identifier
  end


  def to_s
    name
  end


  def to_icon
    case id
    when 'pg_db'
      'fa-database'
    when 'mysql_db'
      'fa-database'
    when 'docker'
      'fa-rocket'
    when 'lb'
      'fa-random'
    when 'log'
      'fa-print'
    end
  end


  def default_options
    case id
    when 'pg_db'
      { port: 5432, connection_timeout: 10 }
    when 'mysql_db'
      { port: 3306, connection_timeout: 10 }
    when 'docker'
      { port: 4243, connection_timeout: 10 }
    when 'lb'
      { port: 80, connection_timeout: 10 }
    when 'log'
      { port: 514, connection_timeout: 10 }
    end
  end


  private


    def get_identifier
      if type == :mysql_db || type == :pg_db
        :db_server
      else
        "#{type}_server".to_sym
      end
    end

end
