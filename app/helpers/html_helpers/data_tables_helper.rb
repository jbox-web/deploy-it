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

module HtmlHelpers
  module DataTablesHelper

    def datatables_translations
      data = {}
      data[:processing]     = t('datatables.processing')
      data[:search]         = t('datatables.search')
      data[:lengthMenu]     = t('datatables.lengthMenu')
      data[:info]           = t('datatables.info')
      data[:infoEmpty]      = t('datatables.infoEmpty')
      data[:infoFiltered]   = t('datatables.infoFiltered')
      data[:infoPostFix]    = t('datatables.infoPostFix')
      data[:loadingRecords] = t('datatables.loadingRecords')
      data[:zeroRecords]    = t('datatables.zeroRecords')
      data[:emptyTable]     = t('datatables.emptyTable')
      data[:paginate] = {}
      data[:paginate][:first]    = t('datatables.paginate.first')
      data[:paginate][:previous] = t('datatables.paginate.previous')
      data[:paginate][:next]     = t('datatables.paginate.next')
      data[:paginate][:last]     = t('datatables.paginate.last')
      data[:aria] = {}
      data[:aria][:sortAscending]  = t('datatables.aria.sortAscending')
      data[:aria][:sortDescending] = t('datatables.aria.sortDescending')
      data[:buttons] = {}
      data[:buttons][:pageLength] = {}
      data[:buttons][:pageLength][:_]    = t('datatables.buttons.pageLength._')
      data[:buttons][:pageLength][:'-1'] = t('datatables.buttons.pageLength.-1')
      data
    end


    def bootstrap_datatables_for(name, opts = {}, &block)
      opts = { html: { width: '100%', class: 'table table-striped table-bordered display responsive no-wrap' } }.merge(opts)
      datatables_for(name, opts, &block)
    end


    def datatables_for(id, opts = {}, &block)
      datatable = EasyAPP::DataTablePresenter.new(self, id, opts)
      yield datatable if block_given?
      datatable
    end

  end
end
