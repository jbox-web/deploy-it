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

class DockerContainerProxy < SimpleDelegator

  def initialize(container)
    super(container)
  end


  def state
    if running?
      :running
    elsif paused?
      :paused
    elsif stopped?
      :stopped
    end
  end


  def running?
    !!is_running? && !paused?
  end


  def paused?
    !!is_paused?
  end


  def stopped?
    !running? && !paused?
  end


  def name
    info['Name']
  end


  def backend_port
    info['NetworkSettings']['Ports']["#{application.port}/tcp"][0]['HostPort']
  rescue => e
    nil
  end


  def backend_address
    info['NetworkSettings']['Ports']["#{application.port}/tcp"][0]['HostIp']
  rescue => e
    nil
  end


  def backend_url
    !backend_address.nil? && !backend_port.nil? ? "#{backend_address}:#{backend_port}" : nil
  end


  def uptime
    DateTime.parse(info['State']['StartedAt'])
  end


  def info
    docker_container.info
  end


  def start
    docker_container.start
  end


  def stop
    docker_container.stop
  end


  def restart
    docker_container.restart
  end


  def pause
    docker_container.pause
  end


  def unpause
    docker_container.unpause
  end


  def delete
    docker_container.delete
  end


  def kill
    docker_container.kill
  end


  def export(&block)
    docker_container.export(&block)
  end


  def exec(command, opts = {}, &block)
    docker_container.exec(command, opts, &block)
  end


  def rename(new_name)
    docker_container.rename(new_name)
  end


  def server
    docker_server.docker_proxy
  end


  private


    def docker_container
      server.get_container(docker_id)
    end


    def is_running?
      return false if docker_server.nil?
      return false if docker_id.nil?
      info['State']['Running'] rescue false
    end


    def is_paused?
      return false if docker_server.nil?
      return false if docker_id.nil?
      info['State']['Paused'] rescue false
    end

end
