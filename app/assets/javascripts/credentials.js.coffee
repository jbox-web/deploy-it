root = exports ? this

root.setCreateCredentialForm = ->
  selectCredentialType()
  selectCreationMode()


selectCredentialType = ->
  setCredentialType()
  $(document).on 'change', '#select-credential-type input:radio', ->
    setCredentialType()


selectCreationMode = ->
  setCreationMode()
  $(document).on 'change', '#select-creation-mode input:radio', ->
    setCreationMode()


setCredentialType = ->
  value = $("#select-credential-type input[type='radio']:checked").val()
  if (value == 'RepositoryCredential::BasicAuth')
    $('#login-pass-form').show()
    $('#ssh-key-form').hide()
  else
    $('#ssh-key-form').show()
    $('#login-pass-form').hide()


setCreationMode = ->
  value = $("#select-creation-mode input[type='radio']:checked").val()
  if (value == 'manual')
    $('#ssh-key-form-manual').show()
  else
    $('#ssh-key-form-manual').hide()
