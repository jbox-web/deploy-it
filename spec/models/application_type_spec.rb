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

describe ApplicationType do

  let(:application_type) { build(:application_type) }

  subject { application_type }

  ## Global validation
  it { should be_valid }

  ## Fields validation
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:version) }
  it { should validate_presence_of(:language) }

  it { should validate_uniqueness_of(:name).scoped_to([:version, :language]) }

  it { should validate_inclusion_of(:language).in_array(%w(php ruby python)) }

  ## Relations validation
  it { should have_many(:applications) }


  it "should render as string" do
    expect(subject.to_s).to eq "#{subject.name} - #{subject.version}"
  end

  it "should have no attributes" do
    expect(subject.has_extra_attributes?).to be false
  end

  it "should accept JSON attributes" do
    data = { "foo" => ["foo", "bar"], "bar" => 1 }
    subject.json_attributes = data
    expect(subject.json_attributes).to eq JSON.pretty_generate(data)
    expect(subject.has_extra_attributes?).to be true
  end

  it "should validate JSON attributes" do
    data = '"foo": ["foo", "bar"], "bar": 1'
    subject.json_attributes = data
    expect(subject).to be_invalid
  end
end
