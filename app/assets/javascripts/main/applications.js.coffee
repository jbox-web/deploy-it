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


root.HandleNestedFields = (event) ->
  if $(event.field).data('toggle') == 'switch'
    element = event.field.find('.bootstrap-switch')
    createBootstrapSwitch(element)
