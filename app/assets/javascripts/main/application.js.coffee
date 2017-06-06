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
#= require jquery-ui/effects/effect-highlight
#= require jquery-ui/widgets/draggable
#= require jquery-ui/widgets/sortable
#= require bootstrap-sprockets
#= require sb-admin/metisMenu
#= require sb-admin/sb-admin-2
#= require sb-admin/bootstrap_helper
#= require datatables/loader
#= require action_form
#= require jquery_nested_form
#= require bootstrap-switch
#= require bootstrap-notify
#= require bootstrap-slider
#= require codemirror
#= require codemirror/modes/javascript
#= require danthes
#= require datetimepicker
#= require highstock-release
#= require select2
#= require smart_listing
#= require zeroclipboard
#= require turbolinks
#= require_tree .

# Turbolinks.enableTransitionCache()
# Turbolinks.enableProgressBar()

onFirstLoad = ->
  setAsyncNotifications()
  setModalBox()

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
$(document).on('nested:fieldAdded', HandleNestedFields)
