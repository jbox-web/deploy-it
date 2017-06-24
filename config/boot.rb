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

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Speedup application loading (https://github.com/Shopify/bootsnap)
require 'bootsnap'
Bootsnap.setup(
  cache_dir:            'tmp/cache', # Path to your cache
  development_mode:     ENV['RAILS_ENV'] == 'development',
  load_path_cache:      true,        # Should we optimize the LOAD_PATH with a cache?
  autoload_paths_cache: true,        # Should we optimize ActiveSupport autoloads with cache?
  disable_trace:        false,       # Sets `RubyVM::InstructionSequence.compile_option = { trace_instruction: false }`
  compile_cache_iseq:   true,        # Should compile Ruby code into ISeq cache?
  compile_cache_yaml:   true         # Should compile YAML into a cache?
)
