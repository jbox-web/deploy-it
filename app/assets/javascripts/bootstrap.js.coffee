root = exports ? this

root.setNavigationSelector = ->
  $('.select2').select2()


root.setBootstrapSwitch = (parent) ->
  elements = parent + ' .bootstrap-switch'
  $(elements).bootstrapSwitch()


root.setAlertDismiss = ->
  $('.alert:not(.dont-dismiss)').delay(3000).slideUp(200, -> $(this).alert('close'))


root.setLightBox = ->
  $(document).delegate '*[data-toggle="lightbox"]', 'click', (event) ->
    event.preventDefault()
    $(this).ekkoLightbox()


root.setPopOver = ->
  $('[data-toggle="popover"]').popover(
    trigger:   $(this).data('trigger'),
    html:      $(this).data('html'),
    placement: $(this).data('placement'),
    content:   -> $($(this).data('source')).html()
  )


root.setCurrentTab = ->
  # show active tab on reload
  if (location.hash != '')
    current_tab = $('a[data-target="' + location.hash + '"]')
    $.ajax({url: current_tab.attr('href'), dataType: 'script'}) if (current_tab.data('remote') == true)
    current_tab.tab('show')

  # remember the hash in the URL without jumping
  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    if(history.pushState)
      history.pushState(null, null, '#' + $(e.target).data('target').substr(1))
    else
      location.hash = '#' + $(e.target).data('target').substr(1)


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
