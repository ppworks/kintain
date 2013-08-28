$ ->
  listen_click_event_images = () ->
    $('form ul.events>li img').on 'click', (e) ->
      $('#post_event_id').val($(@).attr('data-id'))
      $('form').submit()
      return
    return
  init_post_form = () ->
    listen_click_event_images()
    return
  if $('body').hasClass('post_form')
    init_post_form()
    return

  listen_click_day = () ->
    $('section.chart h2').on 'click', (e) ->
      location.href = $(@).parent().find('a').attr('href')
    return
  init_posts = () ->
    listen_click_day()
    return
  if $('body').hasClass('posts')
    init_posts()
    return
  return
