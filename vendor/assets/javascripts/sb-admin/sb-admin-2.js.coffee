# Start Bootstrap - SB Admin 2 v3.3.7+1 (http://startbootstrap.com/template-overviews/sb-admin-2)
# Copyright 2013-2016 Start Bootstrap
# Licensed under MIT (https://github.com/BlackrockDigital/startbootstrap/blob/gh-pages/LICENSE)

LoadSidebar = ->
  $('#side-menu').metisMenu()

AutoResize = ->
    topOffset = 50

    # Width
    if this.window.innerWidth > 0
      width = this.window.innerWidth
    else
      width = this.screen.width

    if width < 768
      $('div.navbar-collapse').addClass('collapse')
      topOffset = 100
    else
      $('div.navbar-collapse').removeClass('collapse')

    # Height
    if this.window.innerHeight > 0
      height = this.window.innerHeight - 1
    else
      height = this.screen.height - 1

    height = height - topOffset
    height = 1 if height < 1
    $('#page-wrapper').css('min-height', (height) + 'px') if height > topOffset

LoadTheme = ->
  LoadSidebar()
  AutoResize()

# Load theme
$(document).on('turbolinks:load', LoadTheme)
$(window).on('resize', AutoResize)
