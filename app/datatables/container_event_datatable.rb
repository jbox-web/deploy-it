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

class ContainerEventDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :l, :t, :link_to_icon, :mark_event_path

  def view_columns
    @view_columns ||= {
      created_at: { source: 'ContainerEvent.created_at', searchable: false },
      type:       { source: 'ContainerEvent.type' },
      message:    { source: 'ContainerEvent.message' },
      id:         { source: 'ContainerEvent.id', searchable: false }
    }
  end


  def data
    records.map do |record|
      {
        created_at: l(record.created_at),
        type:       record.type,
        message:    record.message,
        id:         link_to_icon('fa-check', mark_event_path(record.id), method: :post, remote: :true, title: t('text.mark_as_read')),
        'DT_RowId' => record.id
      }
    end
  end


  def container
    @container ||= options[:container]
  end


  private


    def get_raw_records
      container.events.not_seen
    end

end
