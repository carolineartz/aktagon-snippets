require 'uv'
require 'RedCloth'

class Snippet < ActiveRecord::Base
  THEME = 'active4d'
  include Taggable
  belongs_to :language, counter_cache: true
  belongs_to :user

  validates :title, length: { minimum: 1, maximum: 500 }
  validates :body, length: { minimum: 1, maximum: 100.kilobytes }
  validates :language_id, presence: true

  scope :recent, -> { order('created_at desc').includes(:tags, :user, :language) }

  before_save do
    if changes.include?(:body)
      self.rendered_body = render
      self.version += 1
    end
  end

  # Renders textile and code blocks.
  #
  # 1) render code blocks with ultraviolet and replace code blocks temporarily to avoid textilize escaping them
  # 2) render textile
  # 3) add code blocks back
  def render
    lang = language.external_name
    lines = false
    blocks = []
    # NOTE notextile blocks are always escaped when filter_html is enabled, so we have to work around it
    # by replacing code blocks with this string so RedCloth doesn't filter the HTML inside code blocks
    tag_name = "HzeWAw2hFwsEDZo9PtoU"
    textile = body.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
      code = $3
      code = Uv.parse(code, 'xhtml', lang, lines, THEME)
      blocks << code
      "\n#{tag_name}\n" # Instead of "\n<notextile>#{code}</notextile>\n"
    end
    # http://redcloth.rubyforge.org/classes/RedCloth/TextileDoc.html
    filter = [:filter_html, :filter_styles, :filter_classes, :filter_ids]
    textile = RedCloth.new(textile, filter).to_html
    html = textile.gsub(tag_name).with_index do |match, ix|
      blocks[ix]
    end
    self.rendered_body = html
  end

  def raw(highlighted=true)
    if highlighted
      rendered_body.scan(/\<pre( class="(.+?)")?\>(.+?)\<\/pre\>/m).map { |m| m[2] }.join("\n#######\n")
    else
      body.scan(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m).map { |m| m[2] }.join("\n#######\n")
    end
  end

  def uri(action=nil)
    uri = '/snippets/' + to_param
    uri += "/" + action.to_s if action
    uri
  end

  def body
    self['body'].andand.force_encoding('utf-8')
  end

  def rendered_body
    self['rendered_body'].andand.force_encoding('utf-8')
  end

  def line_count
    @line_count ||= body.lines.count+3 if body.present?
  end

  def to_param
    persisted? ?  "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-').downcase}" : ''
  end

  def disqus_id
    "snippet-#{id}"
  end

  def days_ago
    @days_ago ||= ((Time.now.utc - created_at) / 86_400).to_i if persisted?
  end
end
