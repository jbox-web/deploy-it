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

describe Member do

  before(:each) do
    @member = build(:member_user)
  end

  subject { @member }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:application_id) }

  ## Relations validation
  it { should belong_to(:enrolable) }
  it { should belong_to(:application) }
  it { should have_many(:member_roles).dependent(:destroy) }
  it { should have_many(:roles).through(:member_roles) }


  describe "#type" do
    context "when enrolable is a user" do
      it "should return user type" do
        member = build(:member_user)
        expect(member.type).to eq 'User'
      end
    end

    context "when enrolable is a group" do
      it "should return group type" do
        member = build(:member_group)
        expect(member.type).to eq 'Group'
      end
    end
  end

  describe ".find_or_new" do
    context "when membership does not exist" do
      it "should create a new user member" do
        application = create(:application)
        user = create(:user)
        user_member = Member.find_or_new(application, user)

        expect(user_member.new_record?).to be true
        expect(user_member.deletable?).to be true
        expect(user.roles_for_application(application)).to eq []
      end
    end

    context "when membership already exist" do
      context "and it's a user" do
        it "should return the existing user member" do
          application = create(:application, name: 'toto')
          user, role, member = create_user_membership(application)
          user_member = Member.find_or_new(application, user)

          expect(member.name).to eq user.login
          expect(member.deletable?).to be true
          expect(user_member.new_record?).to be false
          expect(user_member).to eq member
          expect(user.roles_for_application(application)).to eq [role]
        end
      end

      context "and it's a group" do
        it "should return the existing group member" do
          application = create(:application, name: 'toto')
          user, group, role, member = create_group_membership(application)
          user_member = Member.find_or_new(application, user)

          expect(member.name).to eq group.name
          expect(member.deletable?).to be true
          expect(user_member.new_record?).to be false
          expect(user_member.deletable?).to be false
          expect(user.roles_for_application(application)).to eq [role]
        end
      end
    end
  end

end
