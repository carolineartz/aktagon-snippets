$ ->
  $('.copy-button').click (e) ->
    e.preventDefault()

  clip = new ZeroClipboard $('.copy-button'),
    moviePath: "/swf/ZeroClipboard.swf"

  clip.on 'mousedown', (client) ->
    link = $(this)
    $.ajax
      url: link.attr("href") + ".json"
      success: (content) ->
        console.debug('Copied to clipboard: ' + content)
        clip.setText content
      async: false

  clip.on 'complete', (client, args) ->
    link = $(this)
    link.find('.text').html('Copied&hellip;')
