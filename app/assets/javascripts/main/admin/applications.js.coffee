root = exports ? this

root.getApplicationsStatus = ->
  $('.application-status').each ->
    getData(this)
