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

describe MountPoint do

  let(:mount_point) { build(:mount_point) }

  subject { mount_point }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:application_id) }
  it { should validate_presence_of(:source) }
  it { should validate_presence_of(:target) }
  it { should validate_presence_of(:step) }

  it { should validate_inclusion_of(:step).in_array(%w(receive build deploy)) }

  ## Relations validation
  it { should belong_to(:application) }

  it "should render as string" do
    expect(subject.to_s).to eq "#{subject.source}:#{subject.target}"
  end

end
