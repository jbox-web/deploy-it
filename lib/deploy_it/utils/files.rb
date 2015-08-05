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
  module Utils
    module Files
      extend self

      def write_yaml_file(data)
        # Get random file
        file = Tempfile.new('temp')
        filepath = file.path
        file.close!
        # Write file
        write_file(filepath, data.to_yaml)
        return filepath
      end


      def write_file(file, content)
        File.open(file, 'w+') {|f| f.write(content) }
      end

    end
  end
end
