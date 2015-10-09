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

class BuildManager

  attr_reader :build


  def initialize(build)
    @build  = build
    @errors = []
  end


  def runnable?
    perform_validation
    errors.empty?
  end


  def success?
    errors.empty?
  end


  def run!(opts = {})
    # Grab option
    async = opts.fetch(:async, true)

    # Change build state
    build.run!

    # The real job is done here so we can grab
    # errors in synchronous mode (console)
    if async
      build.run_async!('perform_task!', opts)
    else
      result = build.perform_task!(opts)
      @errors.concat(result.errors) if !result.success?
    end
  end


  def errors
    @errors.uniq
  end


  private


    # Check that build is valid
    #
    def perform_validation
      locked?
    end


    # Get build lock
    #
    def locked?
      if build.may_put_in_stack?
        build.put_in_stack!
        true
      else
        @errors.concat(build.errors.full_messages)
        build.cancel!
        false
      end
    end

end
