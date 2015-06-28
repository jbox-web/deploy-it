root = exports ? this

root.useCredentials = ->
  $('#select-credential').hide()
  $('#select-credential').show() if ($('#application_repository_have_credentials').is(':checked'))
  $("#application_repository_have_credentials").bootstrapSwitch(
    onSwitchChange: (event, checked) ->
      if (checked)
        $('#select-credential').show()
        $('#in-use-credential').show()
      else
        $('#select-credential').hide()
        $('#in-use-credential').hide()
  )


root.showSettings = (element) ->
  $(element).slideToggle('fast')
