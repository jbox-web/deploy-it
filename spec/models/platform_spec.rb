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

describe Platform do

  before(:each) do
    @platform = build(:platform)
  end

  subject { @platform }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:identifier) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:identifier).case_insensitive }

  ## Relations validation
  it { should have_many(:servers) }
  it { should have_many(:stages) }

  it "should render as string" do
    expect(@platform.to_s).to eq @platform.name
  end

  context "when platform is used by servers" do
    it "should not be deleted" do
      platform = create(:platform)
      create(:server, platform_id: platform.id)
      expect(platform.destroy).to be false
    end
  end

  context "when platform is used by stages" do
    it "should not be deleted" do
      platform = create(:platform)
      create(:stage, platform_id: platform.id)
      expect(platform.destroy).to be false
    end
  end

end
