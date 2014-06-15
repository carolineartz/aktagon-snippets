$ ->
  # Cookies contain JSON
  $.cookie.json = true
  $('.snippet .content a').attr('target', '_blank')

  # Show username
  user = $.cookie('user')
  signedIn = !!user
  console.dir(user)

  if signedIn
    $('#username').html(' (' + user.login + ')')
    $('.signed-in').toggle()
    $('*[data-user=' + user.id + '] .auth-required').toggle()
  else
    $('.signed-out').toggle()


  # Menu
  $('.expand').click (e) ->
    $this = $(this)
    target = $this.data('target')
    $(target).toggle()
    e.preventDefault()

   # Load Disqus
  $('#show-disqus').click (e) ->
    $('body').animate
      scrollTop: $("#disqus_thread").offset().top
      , 500
    res = $.ajax
        type: "GET",
        url: "http://" + disqus_shortname + ".disqus.com/embed.js",
        dataType: "script",
        cache: true
    #res.success ->
      #$('#show-disqus').hide()
    e.preventDefault()
