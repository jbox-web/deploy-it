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

  before(:all) do
    @user = AnonymousUser.new(firstname: 'Anonymous', lastname: '', email: '', login: '')
  end

  subject { @user }

  it "should have a name" do
    expect(@user.name).to eq I18n.t('label.user.anonymous')
  end

  it "should not have an email" do
    expect(@user.email).to be nil
  end

  it "should not have a time_zone" do
    expect(@user.time_zone).to be nil
  end

  it "should not be logged" do
    expect(@user.logged?).to be false
  end

  it "should not be admin" do
    expect(@user.admin?).to be false
  end

  it "should not be destroyed" do
    expect(@user.destroy).to be false
  end
end
