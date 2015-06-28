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

::SecureHeaders::Configuration.configure do |config|
  config.hsts = {max_age: 20.years.to_i, include_subdomains: false}
  config.x_frame_options = 'DENY'
  config.x_xss_protection = {value: 1, mode: 'block'}
  config.x_content_type_options = 'nosniff'
  config.x_download_options = 'noopen'
  config.csp = false
  # config.csp = {
  #   default_src: "https://* self",
  #   frame_src:   "https://* ",
  #   img_src:     "https://*",
  #   report_uri:  '//example.com/uri-directive'
  # }
end
