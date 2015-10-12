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
