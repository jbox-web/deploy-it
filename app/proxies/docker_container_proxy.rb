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

class DockerContainerProxy

  attr_reader :docker_id
  attr_reader :docker_server


  def initialize(docker_id, docker_server)
    @docker_id     = docker_id
    @docker_server = docker_server
  end


  def running?
    info['State']['Running']
  end


  def paused?
    info['State']['Paused']
  end


  def name
    info['Name']
  end


  def backend_port(port)
    info['NetworkSettings']['Ports']["#{port}/tcp"][0]['HostPort']
  end


  def backend_address(port)
    info['NetworkSettings']['Ports']["#{port}/tcp"][0]['HostIp']
  end


  def uptime
    info['State']['StartedAt']
  end


  def info
    container.info
  end


  def start
    container.start
  end


  def stop
    container.stop
  end


  def restart
    container.restart
  end


  def pause
    container.pause
  end


  def unpause
    container.unpause
  end


  def delete
    container.delete
  end


  def kill
    container.kill
  end


  def export(&block)
    container.export(&block)
  end


  def exec(command, opts = {}, &block)
    container.exec(command, opts, &block)
  end


  def rename(new_name)
    container.rename(new_name)
  end


  private


    def container
      docker_server.get_container(docker_id)
    end

end
