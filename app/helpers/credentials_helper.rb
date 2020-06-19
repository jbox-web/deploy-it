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

module CredentialsHelper

  def sti_credential_path(type = "credential", credential = nil, action = nil)
    send "#{format_sti(action, type, credential)}_path", credential
  end


  def format_sti(action, type, credential)
    action || credential ? "#{format_action(action)}#{type.demodulize.underscore}" : "#{type.demodulize.underscore.pluralize}"
  end


  def format_action(action)
    action ? "#{action}_" : ""
  end

end
