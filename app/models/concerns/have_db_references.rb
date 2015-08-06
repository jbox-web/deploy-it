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

      def check_db_references(model, method = :to_s)
        @references ||= {}
        @references[model] = method
      end


      def references_to_check
        @references ||= {}
      end

    end

  end


  private


    def check_db_references
      checked = {}
      self.class.references_to_check.each do |model, method|
        checked[model] = check_references_on_model(model, method)
      end
      !checked.values.include?(false)
    end


    def check_references_on_model(model, method = :to_s)
      valid      = true
      references = send(model.pluralize)
      if !references.empty?
        errors.add(:base, :undeletable, object_name: model.to_sym, list: references.map(&method).to_sentence)
        valid = false
      end
      valid
    end

end
