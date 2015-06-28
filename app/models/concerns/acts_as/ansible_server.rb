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

module ActsAs
  module AnsibleServer
    extend ActiveSupport::Concern

    included do
      class << self

        def generate_ansible_inventory_file!
          content = {}
          Server.all.map { |s| content[s.host_name] = { ansible_ssh_host: s.ip_address } }
          AnsibleProxy.generate_inventory_file(content)
        end

      end
    end


    def ansible_proxy
      @ansible_proxy ||= AnsibleProxy.new(host_name, private_key, ansible_options)
    end


    def ansible_options
      { user: ssh_user, port: ssh_port }
    end

  end
end
