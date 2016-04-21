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

require 'docker'

class DockerServerProxy

  def initialize(url, opts = {})
    @url = url
    init_connexion(url, opts)
  end


  class << self

    def local_server(opts = {})
      @local_docker_server ||= new('unix:///var/run/docker.sock', opts.merge(docker_options))
    end

    def docker_options
      {
        connect_timeout: Settings.docker_connect_timeout,
        read_timeout:    Settings.docker_read_timeout,
        write_timeout:   Settings.docker_write_timeout,
        tcp_nodelay: true
      }
    end

  end


  def init_connexion(url, opts = {})
    ::Docker.url     = url
    ::Docker.options = opts
    ::Docker.validate_version!
  rescue Excon::Errors::SocketError => e
    DeployIt.file_logger.error e.message
  end


  def reachable?
    ::Docker::Container.all
  end


  def cleanup
    remove_stopped_containers
    remove_unused_images
  end


  def create_container(*args)
    ::Docker::Container.create(*args)
  end


  def hosts?(tag)
    find_container_by_tag(tag).nil? ? false : true
  end


  def find_container_by_tag(tag)
    ::Docker::Container.all.select{ |c| c.info['Image'].include?(tag) }.first
  rescue
    nil
  end


  def get_container(docker_id)
    ::Docker::Container.get(docker_id)
  end


  def get_image(image)
    ::Docker::Image.get(image)
  end


  def image_exists?(image)
    ::Docker::Image.exist?(image)
  end


  def kill_container(docker_id)
    get_container(docker_id).kill
  end


  def stopped_containers
    ::Docker::Container.all(all: true).select { |c| c.info['Status'].include?('Exited') || c.info['Status'] == '' }
  end


  def unused_images
    ::Docker::Image.all().select { |i| i.info['RepoTags'][0] == '<none>:<none>' }
  end


  def remove_stopped_containers
    stopped_containers.each { |c| c.delete(force: true) }
  end


  def remove_unused_images
    unused_images.each { |i| i.delete(force: true) rescue '' }
  end


  def remove_stopped_containers_by_name(name)
    stopped_containers.select { |c| c.info['Image'] == name }.each { |c| c.delete(force: true) }
  end


  def file_exists?(image_name, file, opts = {})
    docker_test(image_name, "test -f #{file};", opts)
  end


  def directory_exists?(image_name, directory, opts = {})
    docker_test(image_name, "test -d #{directory};", opts)
  end


  def run_attached(image_name, command, opts, &block)
    docker_container = create_container(
      'Image' => image_name,
      'Cmd'   => command
    )

    # Launch command and stream output
    docker_container.tap { |c|
      c.start(opts)
    }.attach { |stream, chunk|
      yield chunk if block_given?
    }

    # Wait for completion
    docker_container.wait

    # Commit image to save data
    docker_container.commit('repo' => image_name)

    docker_container.json['State']['ExitCode'] == 0
  end


  def inject_file(image_name:, source_file:, dest_file:, perms: '644', opts: {}, docker_options: {})
    # Get params
    create_parent_dir = opts.delete(:create_parent_dir){ false }
    from_tar_file     = opts.delete(:from_tar_file){ false }
    command           = build_copy_command(dest_file, perms, create_parent_dir, from_tar_file)

    # Inject!
    do_inject_file(image_name, source_file, command, docker_options)
  end


  def push(image, registry)
    raise DeployIt::Error::DockerImageNotFound if !image_exists?(image)
    registry_path = "#{registry}/#{image}"
    docker_command('tag', '-f', image, registry_path)
    docker_command('push', registry_path)
    docker_command('rmi', registry_path)
  end


  def pull(image, registry = nil)
    registry_path = !registry.nil? ? "#{registry}/#{image}" : image
    docker_command('pull', registry_path)
    unless registry.nil?
      docker_command('tag', registry_path, image)
      docker_command('rmi', registry_path)
    end
  end


  private


    def docker_command(*args)
      args = [ '-H', @url ].concat(args)
      Rails.logger.debug "docker #{args.join(' ')}"
      DeployIt::Utils::Exec.execute('docker', args)
    end


    def build_copy_command(dest_file, perms, create_parent_dir = false, from_tar_file = false)
      command = []

      if create_parent_dir
        parent_dir = File.dirname(dest_file)
        if parent_dir == '/'
          parent_dir = dest_file
        end
        command = command.concat(['mkdir', '-p', parent_dir, '&&'])
      end

      if from_tar_file
        command = command.concat(['tar', '-xC', dest_file])
      else
        command = command.concat(['cat', '>', dest_file, '&&', 'chmod', perms, dest_file])
      end

      command.join(' ')
    end


    def do_inject_file(image_name, source_file, destination, opts = {})
      new_image_name = opts.delete(:new_image_name){ image_name }

      docker_container = create_container(
        'Image'     => image_name,
        'Cmd'       => ['/bin/bash', '-c', destination],
        'OpenStdin' => true,
        'StdinOnce' => true
      )

      # Copy!
      docker_container.tap { |c|
        c.start(opts)
      }.attach(stdin: source_file)

      # Wait for completion
      docker_container.wait

      # Commit image to save data
      docker_container.commit('repo' => new_image_name)
    end


    def docker_test(image, test, opts = {})
      docker_container = create_container(
        'Image' => image,
        'Cmd'   => ['/bin/bash', '-c', test, "exit $?"]
      )

      # Test
      docker_container.start(opts)

      # Wait for completion
      docker_container.wait
      docker_container.json['State']['ExitCode'] == 0
    end

end
