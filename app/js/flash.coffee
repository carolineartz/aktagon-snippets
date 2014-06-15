class Flash
  constructor: (@flash_holder, @cookie_prefix) ->
    @flash_holder ?= '#flash'
    @cookie_prefix ?= 'flash_'

  show: ->
    for key in ['info', 'error']
      # Read cookie, e.g. flash_info
      name = @cookie_prefix + key
      value = $.cookie(name)
      if value
        # Set flash holder contents to cookie value
        $(@flash_holder).attr('class', name).html(value).show('fast')
        $.removeCookie(name, path: '/')

$ ->
  new Flash().show()
