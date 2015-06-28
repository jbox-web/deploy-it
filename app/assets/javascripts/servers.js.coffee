root = exports ? this

root.getServerStatus = ->
  $('.connexion-status').each ->
    getData(this)
