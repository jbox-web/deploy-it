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
require 'digest'

describe User do

  VALID_MAIL_ADDRESSES   = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  INVALID_MAIL_ADDRESSES = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]

  context "when password is set" do
    let(:user) { build(:user) }

    subject { user }

    ## Global validation
    it { should be_valid }

    ## Fields validation
    it { should validate_presence_of(:firstname) }
    it { should validate_presence_of(:lastname) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:time_zone) }
    it { should validate_presence_of(:language) }

    it { should validate_length_of(:firstname).is_at_most(50) }
    it { should validate_length_of(:lastname).is_at_most(50) }
    it { should validate_length_of(:password).is_at_least(6) }

    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should allow_value(*VALID_MAIL_ADDRESSES).for(:email) }

    it { should_not allow_value(*INVALID_MAIL_ADDRESSES).for(:email), proc { @user.errors.full_messages } }

    ## Relations validation
    it { should have_many(:ssh_public_keys) }
    it { should have_and_belong_to_many(:groups) }

    it { should have_many(:memberships).class_name('Member').dependent(:destroy) }
    it { should have_many(:applications).through(:memberships) }


    it "should render as string" do
      expect(subject.to_s).to eq subject.full_name
    end

    it "should be logged" do
      expect(subject.logged?).to be true
    end

    it "should have a full name" do
      expect(subject.full_name).to eq "#{subject.firstname} #{subject.lastname}"
    end

    it "should have a notification token" do
      expect(subject.notification_token).to eq Digest::SHA256.new.hexdigest(subject.email)
    end

    it "should have a private notification channel" do
      expect(subject.private_channel).to eq "/private/#{subject.notification_token}"
    end

    it "should have never been connected" do
      expect(subject.last_connection).to eq User.human_attribute_name('never_connected')
    end

    it "should not be anonymous" do
      expect(subject.anonymous?).to be false
    end

    it "should downcase email" do
      user = build(:user, email: "TOTO@TOTO.COM")
      user.valid?
      expect(user.email).to eq 'toto@toto.com'
    end

    describe ".anonymous" do
      it "should return AnonymousUser" do
        expect(User.anonymous).to be_an_instance_of(AnonymousUser)
      end
    end
  end

  context "when password is not set" do
    let(:new_user) { build(:user, password: nil) }
    subject { new_user }
    it { should validate_presence_of(:password) }
    it { should validate_confirmation_of(:password) }
  end

end
