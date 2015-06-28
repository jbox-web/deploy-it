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

describe RepositoryCredential::SshKey do

  before(:each) do
    @ssh_key = build(:ssh_key)
  end

  subject { @ssh_key }

  ## Global validation
  it { should_not be_valid }

  ## Fields validation
  it { should validate_presence_of(:public_key) }
  it { should validate_presence_of(:private_key) }
  it { should validate_presence_of(:fingerprint) }

  ## Relations validation
  it { should have_many(:repositories) }

  describe "with valid ssh_key" do
    before do
      data = DeployIt::SshUtils.generate_ssh_key
      @valid_ssh_key = build(:ssh_key, public_key: data[:public_key], private_key: data[:private_key])
    end
    subject { @valid_ssh_key }
    it { should be_valid }
  end

  describe "with invalid ssh_key" do
    before do
      @invalid_ssh_key = build(:ssh_key, public_key: "fezofkfzepfpzelfpzelfzpeflz", private_key: "fpflezpflzepflzpelfze")
    end
    subject { @invalid_ssh_key }
    it { should_not be_valid }
  end

end
