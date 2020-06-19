# frozen_string_literal: true
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

class ApplicationType < ApplicationRecord

  include HaveDbReferences

  ## Relations
  has_many :applications

  ## Basic Validations
  validates :name,     presence: true, uniqueness: { scope: [:version, :language] }
  validates :version,  presence: true
  validates :language, presence: true, inclusion: { in: DeployIt::AVAILABLE_LANGUAGES }

  ## Additionnal Validations
  validate  :json_validator

  ## Scopes
  scope :by_name_and_version, -> { order(name: :asc, version: :asc) }

  DeployIt::AVAILABLE_LANGUAGES.each do |lang|
    scope lang.to_sym, -> { where(language: lang) }
  end

  ## References checking
  check_db_references :applications

  ## Serializer
  serialize :extra_attributes, JSON


  class << self

    def clone_from(parent)
      parent = find_by_id(parent) unless parent.kind_of? ApplicationType
      copy = ApplicationType.new
      copy.attributes = parent.attributes
      copy
    end

  end


  def to_s
    "#{name} - #{version}"
  end


  def has_extra_attributes?
    !extra_attributes.nil? && !extra_attributes.empty?
  end


  def json_attributes
    JSON.pretty_generate(extra_attributes) unless (extra_attributes.nil? || extra_attributes.empty?)
  rescue
    extra_attributes
  end


  def json_attributes=(attributes)
    self.extra_attributes = attributes unless attributes.empty?
  end


  private


    def json_validator
      self.extra_attributes = JSON::parse(extra_attributes) unless (extra_attributes.nil? || extra_attributes.empty?)
    rescue
      errors.add(:json_attributes, :unserializable)
    end

end
