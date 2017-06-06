root = exports ? this

root.fixBootstrapDateFilter = (element) ->
  $(element).next().width('100%')


root.contextMenuHide = ->
  $('#context-menu').hide()


root.enableContextualMenuForRow = (row) ->
  $(row).addClass('has-context-menu')


root.addRowIfChecked = (table, tr) ->
  checkbox = $($(tr).find('input[type="checkbox"]')[0])
  if checkbox.is(':checked')
    table.row('#' + tr.attr('id'), { page: 'current' }).select()


root.createDatatableWithContextMenu = (element, search_fields, options) ->
  menu_opts =
    ajax:
      url: $(element).data('source')
      type: 'POST'
      data: (d) ->
        $.extend {}, d, { "selected": getSelectedCheckboxIds(element), "not_selected": getNotSelectedCheckboxIds(element) }
    createdRow: (row, data, index) ->
      enableContextualMenuForRow(row)
      addRowIfChecked($(this).DataTable(), $(row))

  new_options = $.extend {}, menu_opts, options

  table = createDatatableWithButtons(element, search_fields, new_options)

  table.on 'xhr.dt', (e, settings, json, xhr) ->
    if json? && json['records_selected']?
      updateSelectAllGlobalCount(element, json['records_selected'])
    else
      return false

  handleSelectAll(element, table)
  setContextualMenuForTable(element, table)

  return table


root.createDatatableWithButtons = (element, search_fields, options) ->
  # Get all buttons from element
  buttons = $(element).data('buttons')

  # Add reset selection button
  if findButton(buttons, 'reset_selection') != null
    buttons = addCallbackToButton(buttons, 'reset_selection', resetSelection)

  # Add select all button
  if findButton(buttons, 'select_all') != null
    buttons = addCallbackToButton(buttons, 'select_all', selectAll)

  # Add reset filters button
  if findButton(buttons, 'reset_filters') != null
    buttons = addCallbackToButton(buttons, 'reset_filters', resetFilters)

  # Add send mail button if needed
  if findButton(buttons, 'email') != null
    buttons = addCallbackToButton(buttons, 'email', saveSelectedAndCallUrl)

  menu_opts =
    buttons: buttons

  new_options = $.extend {}, menu_opts, options

  table = createDatatable(element, search_fields, new_options)
  return table


root.createDatatable = (element, search_fields, options) ->
  table = $(element).DataTable(options)
  init_yadcf(element, table, search_fields)
  return table


root.cleanContextMenu = (event) ->
  target = $(event.target)
  if (target.is('a') && target.hasClass('submenu'))
    event.preventDefault()
    return
  contextMenuHide()


root.window_size = ->
  w = null
  h = null
  if window.innerWidth
    w = window.innerWidth
    h = window.innerHeight
  else if document.documentElement
    w = document.documentElement.clientWidth
    h = document.documentElement.clientHeight
  else
    w = document.body.clientWidth
    h = document.body.clientHeight

  return { width: w, height: h }


init_yadcf = (element, datatable, search_fields) ->
  yadcf.init(datatable, search_fields, 'footer')

  form = $(element + '_wrapper').parent()

  if form?
    $(form).find('.yadcf-filter-wrapper').each ->
      $(this).children().wrapAll('<div class=\"col-md-12\"></div>').wrapAll('<div class=\"input-group\"></div>')
      $(this).children().wrapAll('<div class=\"form-group\"></div>')

    $(form).find('.yadcf-filter-reset-button').addClass('btn btn-default').wrap('<span class=\"input-group-btn\"></span>')
    $(form).find('.yadcf-filter').addClass('form-control')

  if $(element).data('filters')?
    yadcf.exFilterColumn(datatable, $(element).data('filters'))


getSelectedCheckboxIds = (element) ->
  $(element)
    .find('tbody > tr.selected')
    .map -> this.id
    .toArray()


getNotSelectedCheckboxIds = (element) ->
  $(element)
    .find('tbody > tr').not('.selected')
    .map -> this.id
    .toArray()


handleSelectAll = (element, table) ->
  # Handle row selection event
  $(element).on 'select.dt deselect.dt', (e, api, type, items) ->
    if e.type == 'select'
      $('tr.selected input[type="checkbox"]', api.table().container()).prop('checked', true)
    else
      $('tr:not(.selected) input[type="checkbox"]', api.table().container()).prop('checked', false)

    # Update state of "Select all" control
    updateDataTableSelectAllCtrl(table)


  # Handle click on "Select all" control
  $(element + ' thead').on 'click', 'input[type="checkbox"]', (e) ->
    if this.checked
      table.rows({ page: 'current' }).select()
    else
      table.rows({ page: 'current' }).deselect()

    e.stopPropagation()


  # Handle click on heading containing "Select all" control
  $('thead', table.table().container()).on 'click', 'th:first-child', (e) ->
    $('input[type="checkbox"]', this).trigger('click')


  # Handle table draw event
  $(element).on 'draw.dt', ->
    # Update state of "Select all" control
    updateDataTableSelectAllCtrl(table)


contextMenuShow = (event) ->
  mouse_x       = event.pageX
  mouse_y       = event.pageY
  mouse_y_c     = event.clientY
  render_x      = mouse_x
  render_y      = mouse_y
  dims          = null
  menu_width    = null
  menu_height   = null
  window_width  = null
  window_height = null
  max_width     = null
  max_height    = null

  $('#context-menu').css('left', (render_x + 'px'))
  $('#context-menu').css('top', (render_y + 'px'))
  $('#context-menu').html('')

  $.ajax
    url: $(event.target).parents('tbody').first().data('url')
    data: $(event.target).parents('form').first().serialize()
    success: (data, textStatus, jqXHR) ->
      $('#context-menu').html(data)
      menu_width = $('#context-menu').width()
      menu_height = $('#context-menu').height()
      max_width = mouse_x + 2 * menu_width
      max_height = mouse_y_c + menu_height

      ws = window_size()
      window_width = ws.width
      window_height = ws.height

      # display the menu above and/or to the left of the click if needed
      if max_width > window_width
        render_x -= menu_width
        $('#context-menu').addClass('reverse-x')
      else
        $('#context-menu').removeClass('reverse-x')

      if max_height > window_height
        render_y -= menu_height
        $('#context-menu').addClass('reverse-y')
        # adding class for submenu
        if mouse_y_c < 325
          $('#context-menu .folder').addClass('down')
      else
        # adding class for submenu
        if window_height - mouse_y_c < 345
          $('#context-menu .folder').addClass('up')
        $('#context-menu').removeClass('reverse-y')

      render_x = 1 if render_x <= 0
      render_y = 1 if render_y <= 0
      $('#context-menu').css('left', (render_x + 'px'))
      $('#context-menu').css('top', (render_y + 'px'))
      $('#context-menu').show()


callUrl = (button, dt, params, callback) ->
  if button.method == 'redirect'
    window.location.href = button.url
  else if button.method == 'modal'
    openModalBox(button.url)
  else
    options = { url: button.url, method: button.method }
    options = $.extend {}, options, data: params if params
    options = $.extend {}, options, { success: () -> callback() } if callback
    $.ajax options


selectAll = (button, dt) ->
  # Get datatable params
  params = dt.ajax.params()
  # Set length to -1 to get all filtered records
  params['length'] = -1
  # Reset selection
  params['selected'] = []
  params['not_selected'] = []
  # select all rows in the current page
  selectAllRows(dt)
  # Call url
  callUrl(button, dt, params, dt.ajax.reload)


resetSelection = (button, dt) ->
  # Get datatable params
  params = dt.ajax.params()
  # Reset selection
  params['selected'] = []
  params['not_selected'] = []
  # unselect all rows in the current page
  unselectAllRows(dt)
  # Call url
  callUrl(button, dt, params, dt.ajax.reload)


resetFilters = (button, dt) ->
  yadcf.exResetAllFilters(dt)


saveSelectedAndCallUrl = (button, dt) ->
  dt.ajax.reload (data) ->
    callUrl(button, dt)


findButton = (buttons_list, button_name) ->
  i = 0
  len = buttons_list.length
  while i < len
    if buttons_list[i].action == button_name
      return [i, buttons_list[i]]
    i++
  null


addCallbackToButton = (buttons_list, button_name, callback) ->
  # Get button
  [button_idx, button] = findButton(buttons_list, button_name)

  # Remove button from array
  buttons_list.splice(button_idx, 1)

  # Replace action button with JS function
  button.action = (e, dt, node, config) ->
    callback(button, dt)

  # Re-add button to array
  buttons_list.unshift(button)

  return buttons_list


rowIsSelected = (tr) ->
  return tr.hasClass('selected')


addSelectedRow = (table, tr) ->
  table.row('#' + tr.attr('id'), { page: 'current' }).select()
  updateDataTableSelectAllCtrl(table)


selectAllRows = (table) ->
  table.rows({ page: 'current' }).select()


unselectAllRows = (table) ->
  table.rows({ page: 'current' }).deselect()


updateSelectAllGlobalCount = (element, count) ->
  $(element +  '_wrapper .selected-count').html("Nombre total d'éléments sélectionnés : ").append($('<span>').attr('id', 'selected-count-number').html(count))


setContextualMenuForTable = (element, table) ->
  $(element + ' tbody').on 'contextmenu', (event) ->
    target = $(event.target)
    return if target.is('a')
    tr = target.parents('tr').first()
    return if !tr.hasClass('has-context-menu')
    event.preventDefault()
    if !rowIsSelected(tr)
      unselectAllRows(table)
      addSelectedRow(table, tr)

    contextMenuShow(event)


updateDataTableSelectAllCtrl = (table) ->
  $table = table.table().container()
  $chkbox_all = $('tbody input[type="checkbox"]', $table)
  $chkbox_checked = $('tbody input[type="checkbox"]:checked', $table)
  chkbox_select_all = $('thead input[type="checkbox"]', $table).get(0)

  # If none of the checkboxes are checked
  if $chkbox_checked.length == 0
    chkbox_select_all.checked = false
    if 'indeterminate' of chkbox_select_all
      chkbox_select_all.indeterminate = false

  # If all of the checkboxes are checked
  else if $chkbox_checked.length == $chkbox_all.length
    chkbox_select_all.checked = true
    if 'indeterminate' of chkbox_select_all
      chkbox_select_all.indeterminate = false

  # If some of the checkboxes are checked
  else
    chkbox_select_all.checked = true
    if 'indeterminate' of chkbox_select_all
      chkbox_select_all.indeterminate = true

  return
