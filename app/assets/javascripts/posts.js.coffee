$ ->
  listen_click_events = () ->
    $('form ul.events>li img').live 'click', (e) ->
      $('#post_event_id').val($(@).attr('data-id'))
      $('form').submit()
      return
    return
  init_post_form = () ->
    listen_click_events()
    return
  if $('body').hasClass('post_form')
    init_post_form()
    return
  return
