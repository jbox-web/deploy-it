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

class ApplicationDatabase < ActiveRecord::Base

  ## Relations
  belongs_to :application
  belongs_to :server

  ## Basic Validations
  validates :application_id, presence: true, uniqueness: true
  validates :server_id,      presence: true, on: :update
  validates :db_type,        presence: true
  validates :db_name,        presence: true
  validates :db_user,        presence: true
  validates :db_pass,        presence: true


  def db_host
    self.send("get_#{db_type}_host")
  end


  private


    def get_mysql_host
      return '' if server.nil?
      if !server.mysql_host.empty?
        if server.mysql_host == '127.0.0.1'
          if application.language == 'ruby'
            '/var/run/mysqld/mysqld.sock'
          else
            'localhost:/var/run/mysqld/mysqld.sock'
          end
        else
          "#{server.mysql_host}:#{server.mysql_port}"
        end
      else
        "#{server.ip_address}:#{server.mysql_port}"
      end
    end


    def get_postgres_host
      return '' if server.nil?
      if !server.postgres_host.empty?
        if server.postgres_host == '127.0.0.1'
          'localhost:/var/run/mysqld/mysqld.sock'
        else
          "#{server.postgres_host}:#{server.postgres_port}"
        end
      else
        "#{server.ip_address}:#{server.postgres_port}"
      end
    end

end
