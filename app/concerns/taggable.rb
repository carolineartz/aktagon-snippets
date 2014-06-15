module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable
    has_many :tags, through: :taggings

    after_save do
      Tag.delete_orphans
    end
  end

  def tag_list=(new_tags)
    self.tags.clear
    new_tags.downcase!
    new_tags = new_tags.split(',').map(&:strip).reject(&:blank?).uniq
    new_tags.each do |name|
      tag(name)
    end
  end

  def tag_list
    tags.collect(&:name)
  end

  protected

  def tag(name)
    name.strip!
    tag = Tag.find_or_create_by! name: name
    self.taggings.find_or_initialize_by tag_id: tag.id
    tag
  end
end
