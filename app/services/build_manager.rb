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

  attr_reader :task
  attr_reader :async
  attr_reader :opts


  def initialize(task, opts = {})
    @task   = task
    @async  = opts.delete(:async){ true }
    @opts   = opts
    @errors = []
  end


  def runnable?
    perform_validation
    errors.empty?
  end


  def success?
    errors.empty?
  end


  def run!
    # Actually it just gets the lock.
    # The real job is done here so we can grab
    # errors in synchronous mode (console)
    task.run!
    if async
      task.run_async!('perform_task!', opts)
    else
      result = task.perform_task!(opts)
      @errors.concat(result.errors) if !result.success?
    end
  end


  def errors
    @errors.uniq
  end


  private


    def perform_validation
      if task_lockable?
        true
      else
        false
      end
    end


    def task_lockable?
      if task.may_put_in_stack?
        task.put_in_stack!
        true
      else
        @errors.concat(task.errors.full_messages)
        task.cancel!
        false
      end
    end

end
