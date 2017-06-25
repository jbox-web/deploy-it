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

describe Role do

  let(:role) { build(:role) }

  subject { role }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }

  ## Relations validation
  it { should have_many(:member_roles).dependent(:destroy) }
  it { should have_many(:members).through(:member_roles) }

  it { should serialize(:permissions).as(Array) }


  it "should render as string" do
    expect(subject.to_s).to eq subject.name
  end


  describe "#permissions=" do
    before { subject.permissions = [:edit_container] }
    it "should save role's permissions" do
      expect(subject.permissions).to eq [:edit_container]
    end
  end


  describe "#setable_permissions" do
    it "should return an array of Permissions" do
      expect(subject.setable_permissions).to be_an_instance_of Array
    end
  end


  describe "#allowed_to?" do
    before { subject.permissions << :view_application }

    it "can take a symbol" do
      expect(subject.allowed_to?(:view_application)).to be true
    end

    it "can take a hash" do
      expect(subject.allowed_to?(action: :show, controller: :applications)).to be true
    end
  end

  describe "#builtin?" do
    context "the role is an application member role" do
      it { expect(subject.builtin?).to be false }
    end
    context "the role is a builtin role" do
      role = Role.non_member
      it { expect(role.builtin?).to be true }
    end
  end

  describe "#anonymous?" do
    context "the role is an application member role" do
      it { expect(subject.anonymous?).to be false }
    end
    context "the role is a builtin role" do
      role = Role.anonymous
      it { expect(role.anonymous?).to be true }
    end
  end

  describe "#member?" do
    context "the role is an application member role" do
      it { expect(subject.member?).to be true }
    end
    context "the role is a builtin role" do
      role = Role.non_member
      it { expect(role.member?).to be false }
    end
  end
end
