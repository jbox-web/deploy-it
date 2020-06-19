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

module DCI
  module Roles
    class RepositoryCredentialsManager < Base


      def create_credential(params = {})
        credential = get_credential_type(params).constantize.new
        credential_form = CredentialCreationForm.new(credential)
        credential_form.submit(params)
        credential_form.save ? context.render_success : context.render_failed(locals: { credential: credential_form })
      end


      def update_credential(credential, params = {})
        credential.update(params) ? context.render_success : context.render_failed(locals: { credential: credential })
      end


      def delete_credential(credential)
        credential.destroy ? context.render_success : context.render_failed
      end


      private


        def get_credential_type(params)
          accepted_klasses.include?(params[:type]) ? params[:type] : default_klass
        end


        def default_klass
          'RepositoryCredential'
        end


        def accepted_klasses
          ['RepositoryCredential::BasicAuth', 'RepositoryCredential::SshKey']
        end

    end
  end
end
