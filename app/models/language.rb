class Language < ActiveRecord::Base
  has_many :snippets
  scope :used, -> { where('snippets_count > 0').order('snippets_count desc') }

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
