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

describe Stage do

  let(:stage) { build(:stage) }

  subject { stage }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:identifier) }
  it { should validate_presence_of(:platform_id) }

  it { should validate_uniqueness_of(:identifier).scoped_to(:platform_id) }

  ## Relations validation
  it { should belong_to(:platform) }
  it { should have_many(:applications) }


  it "should render as string" do
    expect(subject.to_s).to eq subject.name
  end


  it "should have a full name" do
    expect(subject.full_name).to eq "#{subject.platform.name} - #{subject.name}"
  end


  context "when stage is not linked to containers" do
    it "should be deleted" do
      platform = create(:platform)
      stage = create(:stage, platform: platform)
      expect { stage.destroy }.to change(Stage, :count).by(-1)
    end
  end

  context "when stage is linked to containers" do
    it "should not be deleted" do
      platform = create(:platform)
      stage = create(:stage, platform: platform)
      create(:application, stage: stage)
      expect { stage.destroy }.to change(Stage, :count).by(0)
    end
  end
end
