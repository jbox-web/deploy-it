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

class ApplicationContext < ContextBase

  include ApplicationCommon


  def create(wizard_form, user)
    application = wizard_form.object
    if wizard_form.save
      application.create_relations!(user: user)
      application.run_async!('bootstrap!')
      context.render_create_success(application)
    else
      context.render_create_failed(locals: { application: application })
    end
  end


  def destroy(application)
    application.marked_for_deletion = true
    application.save!
    application.run_async!('destroy_forever!')
    context.render_destroy_success
  end

end
