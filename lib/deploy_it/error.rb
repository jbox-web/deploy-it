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

module DeployIt
  module Error

  # The default error. It's never actually raised, but can be used to catch all
  # gem-specific errors that are thrown as they all subclass from this.
  class DeployItError < StandardError; end

  # Raised when invalid arguments are passed to a method.
  class ArgumentError < DeployItError; end

  # Raised when a file or a container already exists.
  class AlreadyExistError < DeployItError; end

  # Raised when a file or a container does not exists.
  class NeverDeployedError < DeployItError; end

  # Raised when a file or a container does not exists.
  class ServerNotFoundError < DeployItError; end

  # Raised when a file or a container is not found.
  class RepositoryNotFoundError < DeployItError; end

  # Raised when a file or a container is not found.
  class DockerImageNotFound < DeployItError; end

  # Raised when a Git revision is not found on Container build.
  class GitRevisionNotFoundError < DeployItError; end

  # Raised when a file or a container already exists.
  class ForbiddenError < DeployItError; end

  # Raised when an IO action fails.
  class IOError < DeployItError; end

  end
end
