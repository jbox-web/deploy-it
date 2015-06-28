# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require jquery-ui/effect
#= require jquery-ui/effect-highlight
#= require jquery-ui/sortable
#= require bootstrap-sprockets
#= require bootstrap-switch
#= require bootstrap-notify
#= require codemirror
#= require codemirror/modes/javascript
#= require danthes
#= require select2
#= require zeroclipboard
#= require turbolinks
#= require_tree .

Turbolinks.enableTransitionCache()
Turbolinks.enableProgressBar()

onFirstLoad = ->
  setAsyncNotifications()
  setLightBox()

onTurboLoad = ->
  # Common helper to set interface
  setNavigationSelector()
  setCurrentTab()
  setAlertDismiss()

beforeChange = ->
  ZeroClipboard.destroy()

$(document).ready(onFirstLoad)
$(document).ready(onTurboLoad)
$(document).on('page:load', onTurboLoad)
$(document).on('page:before-change', beforeChange)
