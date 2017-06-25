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

describe AnonymousUser do

  let(:user) { AnonymousUser.new(firstname: 'Anonymous', lastname: '', email: '') }

  subject { user }

  it "should have a name" do
    expect(subject.name).to eq I18n.t('label.user.anonymous')
  end

  it "should not have an email" do
    expect(subject.email).to be nil
  end

  it "should not have a time_zone" do
    expect(subject.time_zone).to be nil
  end

  it "should not be logged" do
    expect(subject.logged?).to be false
  end

  it "should not be admin" do
    expect(subject.admin?).to be false
  end

  it "should not be destroyed" do
    expect(subject.destroy).to be false
  end
end
