App.cable.subscriptions.create { channel: "DataChannel" },
  received: (data) ->
    if data.event_type == 'notification'
      displayGrowlMessage(data)
    else if data.event_type == 'view_refresh'
      triggerViewRefresh(data)
    else if data.event_type == 'progress_bar'
      updateProgressBar(data)
    else if data.event_type == 'console_stream'
      console.log(data)


displayGrowlMessage = (data) ->
  growl_data =
    title:   data.title
    message: data.message
    icon:    data.icon

  growl_options =
    type:  data.type
    delay: 0
    template: growlTemplate()
    animate:
      enter: 'animated fadeInRight'
      exit:  'animated fadeOutRight'

  $.notify growl_data, growl_options


growlTemplate = ->
  '<div data-notify="container" class="col-xs-11 col-sm-3 alert alert-{0}" role="alert">' +
    '<button type="button" aria-hidden="true" class="close" data-notify="dismiss">×</button>' +
    '<span data-notify="icon"></span> ' +
    '<span data-notify="title">{1}</span> ' +
    '<span data-notify="message">{2}</span>' +
    '<a href="{3}" target="{4}" data-notify="url"></a>' +
  '</div>';


triggerViewRefresh = (data) ->
  current_controller = $('body').data('controller')
  current_action     = $('body').data('action')
  context  = data['context']
  triggers = data['triggers']

  if context.controller == current_controller && context.action == current_action
    $.each triggers, (index, trigger) ->
      eval(trigger)


refreshView = (url) ->
  $.ajax({ url: url, dataType: 'script' })


updateProgressBar = (data) ->
  progressBar = $('#' + data.target)
  if progressBar.length > 0
    progressBar.parent().removeClass('hide')
    progressBar.width(data.progress + '%')
    progressBar.html(data.progress + '%')
