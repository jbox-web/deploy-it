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

describe MemberRole do

  let(:member_role) { build(:member_role) }

  subject { member_role }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:role) }

  ## Relations validation
  it { should belong_to(:member) }
  it { should belong_to(:role) }

  it { should respond_to(:inherited?) }


  describe "#add_role_to_group_users" do
    it "should create member_role" do
      application = create(:application, name: 'toto')
      user, group, role, member = create_group_membership(application)
      expect(application.calculated_members).to eq [user]
      expect(user.roles_for_application(application)).to eq [role]
    end
  end

  describe "#remove_member_if_empty" do
    it "should remove member_role" do
      application = create(:application, name: 'toto')
      user, group, role, member, member_role = create_group_membership(application)
      member_role.destroy
      expect(application.calculated_members).to eq []
    end
  end

end
