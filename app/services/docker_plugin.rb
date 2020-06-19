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

class DockerPlugin

  include Helpers::Docker

  class << self

    def plugins
      @plugins ||= []
    end


    def file_logger
      @logger ||= DeployIt.file_logger
    end


    def inherited(klass)
      @plugins ||= []
      @plugins << klass
    end


    def execute(step, application, docker_connection, logger, docker_options = {})
      begin
        plugins.each do |plugin_class|
          if plugin_class.method_defined?(step)
            plugin_class.new(application, docker_connection, logger, docker_options).send(step)
          end
        end
      rescue => e
        file_logger.error e.message
      end
    end

  end


  attr_reader :application
  attr_reader :docker_connection
  attr_reader :logger
  attr_reader :docker_options


  def initialize(application, docker_connection, logger, docker_options = {})
    @application       = application
    @docker_connection = docker_connection
    @logger            = logger
    @docker_options    = docker_options
    init_plugin if self.respond_to?(:init_plugin)
  end

end
