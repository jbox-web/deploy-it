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

class Hash

  # Appends a string to a hash key's value after a space character
  # (Good for merging CSS classes in options hashes)
  #
  def append_merge!(key, value)
    # just return self if value is blank
    return self if value.blank?

    current_value = self[key]

    # just merge if it doesn't already have that key
    self[key] = value and return if current_value.blank?

    # raise error if we're trying to merge into something that isn't a string
    raise ArgumentError, 'Can only merge strings' unless current_value.is_a?(String)

    self[key] = [current_value, value].compact.join(' ')
  end

end
