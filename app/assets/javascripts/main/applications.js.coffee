root = exports ? this

root.toggleCredentials = (event, checked) ->
  if (checked)
    $('#select-credential').show()
    $('#in-use-credential').show()
  else
    $('#select-credential').hide()
    $('#in-use-credential').hide()


root.showSettings = (element) ->
  $(element).slideToggle('fast')


root.callToggleUrl = (event, checked) ->
  url   = $(event.target).data('url')
  field = $(event.target).data('field')
  $.ajax url: url, method: 'post', dataType: 'script', data: { toggle: { field: field, checked: checked } }


root.setNavigationSelector = ->
  $('.select2').select2()


root.setBootstrapSwitch = (parent) ->
  elements = parent + ' .bootstrap-switch'
  $(elements).each (index, element) ->
    createBootstrapSwitch(element)


root.reloadSmartListing = ->
  $(SmartListing.config.class_name('main')).smart_listing()
  $(SmartListing.config.class_name('controls')).smart_listing_controls()


root.HandleNestedFields = (event) ->
  if $(event.field).data('toggle') == 'switch'
    element = event.field.find('.bootstrap-switch')
    createBootstrapSwitch(element)


root.setJquerySortable = ->
  # Return a helper with preserved width of cells
  sortableFixHelper = (e, ui) ->
    ui.children().each -> $(this).width($(this).width())
    # return ui to no break chain
    ui

  sortableHelper = (element) ->
    if ($(element).is("tbody"))
      sortableFixHelper
    else if ($(element).is("ul"))
      'clone'

  sortableItems = (element) ->
    if ($(element).is("tbody"))
      "tr:not(.ui-state-disabled)"
    else if ($(element).is("ul"))
      "li:not(.ui-state-disabled)"

  $('.sortable').each ->
    $(this).sortable(
      axis:   'y',
      handle: '.handle',
      helper: sortableHelper(this),
      items:  sortableItems(this),
      update: -> $.post($(this).data('update-url'), $(this).sortable('serialize'))
    ).disableSelection()


root.setCodeMirror = ->
  $('.code-mirror').each ->
    id = $(this).attr('id')
    editor = CodeMirror.fromTextArea(document.getElementById(id), {
      mode:              $(this).data('code-type'),
      tabSize:           2,
      theme:             "default",
      lineNumbers:       true,
      lineWrapping:      true,
      styleActiveLine:   true,
      matchBrackets:     true,
      autoCloseBrackets: true,
      autofocus:         true,
      extraKeys: {
        "Ctrl-Q": "toggleComment",
        "F11": (cm) -> cm.setOption("fullScreen", !cm.getOption("fullScreen")),
        "Esc": (cm) -> cm.setOption("fullScreen", false) if (cm.getOption("fullScreen"))
      }
    })

    editor.on 'change', (instance, object) -> $(id).text(instance.getValue())
    refresh = -> editor.refresh()
    setTimeout(refresh, 0)


root.setZeroClipBoard = (element) ->
  # Create ZeroClipboard object
  client = new ZeroClipboard($(element))

  client.on 'ready', ->
    $('#global-zeroclipboard-html-bridge').tooltip(
      title: $(element).data('label-to-copy'),
      placement: 'right'
    )
    client.on 'beforecopy', -> $('#global-zeroclipboard-html-bridge').tooltip('show')
    client.on 'aftercopy',  -> $('.tooltip .tooltip-inner').text($(element).data('label-copied'))
