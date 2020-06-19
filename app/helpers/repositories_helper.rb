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

module RepositoriesHelper

  def render_commit_distance(commit_hash)
    from_id   = commit_hash[:from][:commit_id][0..6]
    from_auth = commit_hash[:from][:author][:name] rescue ''
    from_mess = commit_hash[:from][:message].strip

    to_id   = commit_hash[:to][:commit_id][0..6]
    to_auth = commit_hash[:to][:author][:name]
    to_mess = commit_hash[:to][:message].strip

    "From #{from_id} (#{from_auth} : #{from_mess}) -> To #{to_id} (#{to_auth} : #{to_mess})"
  end

end
