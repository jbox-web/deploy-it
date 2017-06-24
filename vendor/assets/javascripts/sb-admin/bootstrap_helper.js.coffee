root = exports ? this

# Autoload modal boxes
$(document).on 'click', 'a[data-toggle="ajax-modal"]', (event) ->
  event.preventDefault()
  draggable = $(this).data('draggable')
  size      = $(this).data('modal-size')
  openModalBox($(this).attr('href'), draggable, size)


root.openModalBox = (url, draggable, size) ->
  $.get url, (data) ->
    if draggable
      $('#modal-holder').html(data).find('.modal').modal().draggable()
    else
      $('#modal-holder').html(data).find('.modal').modal()
    if size
      $('.modal-dialog').addClass('modal-' + size)


root.createBootstrapSwitch = (element) ->
  callback = $(element).data('switch-callback')
  if callback
    $(element).bootstrapSwitch(onSwitchChange: (event, checked) -> eval(callback))
  else
    $(element).bootstrapSwitch()


root.toggleElement = (event, checked, element) ->
  if (checked)
    $(element).show()
  else
    $(element).hide()


root.highlight = (element) ->
  $(element).effect('highlight', { color: '#B0D6D6' }, 1500)


root.toggleBooleanIcon = (element) ->
  icon = $(element)
  if icon.hasClass('fa-times')
    icon.removeClass('fa-times')
    icon.removeClass('fa-important')
    icon.addClass('fa-check')
    icon.addClass('fa-success')
  else
    icon.removeClass('fa-check')
    icon.removeClass('fa-success')
    icon.addClass('fa-times')
    icon.addClass('fa-important')


root.toggleCheckboxes = (element, selector) ->
  all_checked = $(element).is(':checked')
  $(selector).each ->
    $(this).prop('checked', all_checked)
    if all_checked == true
      $(this).parent().parent().addClass('selected')
    else
      $(this).parent().parent().removeClass('selected')


root.setAlertDismiss = ->
  $('.alert:not(.dont-dismiss)').delay(3000).slideUp(200, -> $(this).alert('close'))


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
