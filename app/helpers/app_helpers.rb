module AppHelpers
  #
  # Render a JavaScript include tag.
  #
  def js_tag(name)
    file = App.asset_path(name, :js)
    content_tag :script, nil, src: file, type: 'text/javascript'
  end

  #
  # Render a CSS include tag.
  #
  def css_tag(name)
    file = App.asset_path(name, :css)
    content_tag :link, nil, href: file, rel: 'stylesheet', type: 'text/css'
  end

  def signed_in?
    !!current_user
  end

  def error_class(obj, field)
    obj.errors.has_key?(field) ? 'error' : ''
  end

  def dropdowns
    @languages = Language.used.to_a
    @tags = Tag.order('name asc').to_a
    partial 'layouts/_dropdowns'
  end

  def t(*args)
    ::I18n::t(*args)
  end

  def authenticity_token
    # BUG https://github.com/rkh/rack-protection/blob/master/lib/rack/protection/authenticity_token.rb
    session[:csrf] = SecureRandom.hex(128) unless session.has_key?(:csrf)
    %Q{<input type="hidden" name="authenticity_token" value="#{session[:csrf]}"/>}
  end

  def snippet_link(snippet)
    content_tag :a, snippet.title, href: snippet.uri
  end

  def language_link(language, options=nil)
    name = options.fetch(:name) { language.name }
    href = '/languages/' + language.to_param
    content_tag(:a, name, href: href)
  end

  def tag_link(tag)
    href = '/tags/' + tag.to_param
    content_tag(:a, tag.name, href: href)
  end

  def content_tag(name, content, attributes = nil)
    name = html_escape(name) unless name.html_safe?
    content = html_escape(content) unless content.html_safe?
    attributes = attributes.map do |name, value|
      value = html_escape(value) unless value.html_safe?
      %Q{#{name}="#{value}"}
    end if attributes && attributes.any?
    start = [name, attributes.join(" ")].reject(&:nil?).join(' ')
    "<#{start}>#{content}</#{name}>"
  end

  def paginate(collection)
    options = {
      #renderer: BootstrapPagination::Sinatra,
      inner_window: 2,
      outer_window: 2,
      page_links: false,
      previous_label: '&laquo; previous',
      next_label: 'next &raquo;'
    }
    will_paginate collection, options
  end
end
