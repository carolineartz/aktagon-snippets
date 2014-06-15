require './app/models/user'

class Tag < ActiveRecord::Base
  has_many :taggings

  has_many :snippets, through: :taggings, source: :taggable, source_type: Snippet
  has_many :users, through: :taggings, source: :taggable, source_type: User

  validates :name, uniqueness: { scope: [ :taggable_type, :taggable_id ] }

  # Delete orphans
  def self.delete_orphans
    Tag.connection.execute("
      DELETE tags FROM tags
      LEFT JOIN taggings
      ON tags.id = taggings.tag_id
      WHERE taggings.id IS NULL;
    ")
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
