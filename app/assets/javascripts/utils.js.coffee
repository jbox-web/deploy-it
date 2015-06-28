root = exports ? this

root.currentController = ->
  $('body').data('controller')


root.currentAction = ->
  $('body').data('action')


root.getData = (element) ->
  url     = $(element).data("refresh-url")
  icons   = $(element).children('span').children('i')
  icons.each ->
    $(this).removeClass()
    $(this).addClass('fa fa-spinner fa-spin fa-align')
  $.ajax url: url, dataType: 'script'


root.toggleCheckboxesBySelector = (selector) ->
  all_checked = true
  $(selector).each -> all_checked = false if !($(this).is(':checked'))
  $(selector).each -> this.checked = !all_checked


root.highlight = (element) ->
  $(element).effect("highlight", {color: '#B0D6D6'}, 1500)
