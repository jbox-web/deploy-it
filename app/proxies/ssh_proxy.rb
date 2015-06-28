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

class SshProxy

  attr_reader :host
  attr_reader :user
  attr_reader :port
  attr_reader :private_key


  def initialize(host, user, port, private_key)
    @host        = host
    @user        = user
    @port        = port
    @private_key = private_key
  end


  def execute(command)
    DeployIt::SshUtils.execute_ssh_command(host, user, command, ssh_options)
  end


  def ssh_options
    { config: false, use_agent: false, keys_only: true, port: port, key_data: [private_key] }
  end

end
