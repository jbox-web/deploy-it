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

module HaveDbReferences
  extend ActiveSupport::Concern

  included do

    ## Callbacks
    before_destroy :check_db_references

    class << self

      def check_db_references(relation, method = :to_s)
        @references ||= {}
        @references[relation.to_sym] = method
      end


      def references_to_check
        @references ||= {}
      end

    end

  end


  private


    def check_db_references
      checked = {}
      self.class.references_to_check.each do |relation, method|
        checked[relation] = check_references_on_relation(relation, method)
      end
      !checked.values.include?(false)
    end


    def check_references_on_relation(relation, method = :to_s)
      references = send(relation)
      errors.add(:base, :undeletable, object_name: relation, list: references.map(&method).to_sentence) unless references.empty?
      !!references.empty?
    end

end
