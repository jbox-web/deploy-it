root = exports ? this

root.resetForm = (form) ->
  $(form).trigger('reset')
  $(form).find('input[type=text], textarea').val('')
  $(form).find('span.help-block').remove()
  $(form).find('div.form-group').removeClass('has-error')
