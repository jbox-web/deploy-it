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

describe Application do

  let(:application) { build(:application) }
  subject { application }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  # it { should validate_presence_of(:name) }
  # it { should validate_presence_of(:identifier) }
  # it { should validate_presence_of(:application_type_id) }
  # it { should validate_presence_of(:repository) }
  # it { should validate_uniqueness_of(:identifier).case_insensitive }

  ## Relations validation
  it { should have_many(:members).dependent(:destroy) }
  it { should have_many(:users).through(:members).source(:enrolable) }
  it { should have_many(:groups).through(:members).source(:enrolable) }

  it { should belong_to(:application_type) }
  it { should belong_to(:stage) }

  it { should have_many(:env_vars).dependent(:destroy) }
  it { should have_many(:mount_points).dependent(:destroy) }
  it { should have_many(:domain_names).dependent(:destroy) }

  it { should have_many(:configs).dependent(:destroy) }
  it { should have_many(:pushes).dependent(:destroy) }
  it { should have_many(:builds).dependent(:destroy) }
  it { should have_many(:releases).dependent(:destroy) }
  it { should have_many(:containers).dependent(:destroy) }

  it { should have_one(:distant_repo).dependent(:destroy).class_name('ApplicationRepository') }
  it { should have_one(:local_repo).dependent(:destroy).class_name('ContainerRepository') }
  it { should have_one(:database).dependent(:destroy).class_name('ApplicationDatabase') }
  it { should have_one(:ssl_certificate).dependent(:destroy) }

  it { should have_many(:domain_aliases).conditions(mode: 'alias').class_name('DomainName') }
  it { should have_many(:domain_redirects).conditions(mode: 'redirect').class_name('DomainName') }

  ## MultiStep Wizard methods
  it { should respond_to(:steps) }
  it { should respond_to(:current_step) }
  it { should respond_to(:current_index) }
  it { should respond_to(:total_steps) }
  it { should respond_to(:step_forward) }
  it { should respond_to(:step_back) }
  it { should respond_to(:first_step?) }
  it { should respond_to(:last_step?) }
  it { should respond_to(:current_step_valid?) }
  it { should respond_to(:all_steps_valid?) }

  ## Delegator
  it { should delegate_method(:platform).to(:stage) }
  it { should respond_to(:type)}

  describe "#calculated_members" do
    it "should return application's member (user + group)" do
      application = create(:application)

      manager   = create(:user)

      developer = create(:user)
      group = create(:group)
      group.users << developer

      application.members << Member.new(role_ids: [create_role(:manager).id], enrolable_type: 'User',  enrolable_id: manager.id)
      application.members << Member.new(role_ids: [create_role(:developer).id], enrolable_type: 'Group',  enrolable_id: group.id)

      expect(application.calculated_members).to eq [manager, developer]
    end
  end

  describe ".visible_condition" do
    context "when user is not a member" do
      it "should not be visible" do
        application = create(:application)
        user = create(:user)

        expect(Application.visible_condition(user)).to eq "1=0"
        expect(Application.visible(user, application: application)).to eq []
        expect(application.visible?(user)).to be false
        expect(user.member_of?(application)).to be false
      end
    end

    context "when user is admin" do
      it "should be visible" do
        application = create(:application)
        user = create(:user, admin: true)

        expect(Application.visible_condition(user)).to eq ""
        expect(Application.visible(user, application: application)).to eq [application]
        expect(application.visible?(user)).to be true
        expect(user.member_of?(application)).to be false
      end
    end

    context "when user is a member" do
      it "should be visible" do
        application = create(:application)
        user = create(:user)
        application.members << Member.new(role_ids: [create_role(:manager).id], enrolable_type: 'User',  enrolable_id: user.id)

        # expect(Application.visible_condition(user)).to eq "applications.id IN (67)"
        expect(Application.visible(user, application: application)).to eq [application]
        expect(application.visible?(user)).to be true
        expect(user.member_of?(application)).to be true
      end
    end

  end

end
