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

require "rails_helper"

describe SessionsController do

  let(:user){ create(:user) }

  describe "POST #create" do
    it "assigns User.current to the current_user" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, user: {
                      login: user.login,
                      password: user.password
                    }
      expect(User.current).to eq user
    end
  end

  describe 'DELETE destroy' do
    before do
      sign_in user
    end

    it "assigns User.current to nil" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      delete :destroy
      expect(User.current).to be_an_instance_of(AnonymousUser)
    end
  end

end
