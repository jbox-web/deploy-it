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

require 'rails_helper'

describe PlatformCredential do

  let(:credential) { build(:platform_credential) }

  subject { credential }

  ## Global validation
  it { should_not be_valid }

  ## Basic Validations
  it { should validate_presence_of(:platform_id) }
  it { should validate_presence_of(:fingerprint) }
  it { should validate_presence_of(:public_key) }
  it { should validate_presence_of(:private_key) }

end
