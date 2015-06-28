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

describe Server do

  before(:each) do
    @server = build(:server)
  end

  subject { @server }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:host_name) }
  it { should validate_presence_of(:ip_address) }
  it { should validate_presence_of(:platform_id) }
  it { should validate_presence_of(:ssh_user) }
  it { should validate_presence_of(:ssh_port) }

  it { should validate_uniqueness_of(:host_name) }
  it { should validate_uniqueness_of(:ip_address) }

  it { should validate_length_of(:host_name).is_at_most(250) }

  it { should validate_numericality_of(:ssh_port).only_integer }


  ## Relations validation
  it { should belong_to(:platform) }


  it "should render as string" do
    expect(@server.to_s).to eq @server.host_name
  end

  context "when ip_address is invalid" do
    it "should not be valid" do
      server = build(:server, ip_address: '192.168.1.256')
      expect(server).to_not be_valid
    end
  end

end
