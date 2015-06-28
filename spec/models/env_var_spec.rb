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

describe EnvVar do

  before(:each) do
    @env_var = build(:env_var)
  end

  subject { @env_var }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:application_id) }
  it { should validate_presence_of(:key) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:step) }

  it { should validate_uniqueness_of(:key).scoped_to([:application_id, :step]).case_insensitive }
  it { should validate_inclusion_of(:step).in_array(%w(receive build deploy)) }

  ## Relations validation
  it { should belong_to(:application) }

  ## Callbacks
  # before_validation { self.key = key.upcase if !key.nil? }
end
