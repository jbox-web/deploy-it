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

describe Group do

  let(:group) { build(:group) }

  subject { group }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  ## Relations validation
  it { should have_and_belong_to_many(:users) }
  it { should have_many(:memberships).class_name('Member').dependent(:destroy) }
  it { should have_many(:applications).through(:memberships) }

  it { should respond_to(:members) }

  it "should render as string" do
    expect(subject.to_s).to eq subject.name
  end

  context "when a group is assigned to an application" do
    before(:each) do
      @application = create(:application)
      @group = create(:group)
      @role = create_role(:developer)
      @application.members << Member.new(role_ids: [@role.id], enrolable_type: 'Group',  enrolable_id: @group.id)
      @user = create(:user)
    end

    context "when user is added to group" do
      it "should update application's members" do
        @group.users << @user

        expect(@group.members).to eq [@user]
        expect(@application.calculated_members).to eq [@user]
        expect(@user.roles_for_application(@application)).to eq [@role]
      end
    end

    context "when user is removed from group" do
      it "should update application's members" do
        @group.users.delete(@user)

        expect(@group.members).to eq []
        expect(@application.calculated_members).to eq []
      end
    end
  end

end
