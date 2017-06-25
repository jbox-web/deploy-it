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

describe Build do

  let(:build_o) { build(:build) }

  subject { build_o }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:application_id) }
  it { should validate_presence_of(:author_id) }
  it { should validate_presence_of(:push_id) }
  it { should validate_presence_of(:request_id) }
  it { should validate_presence_of(:state) }

  ## Relations validation
  it { should belong_to(:application) }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }
  it { should belong_to(:push) }

end
