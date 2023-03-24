class Tag < ApplicationRecord
  belongs_to :issue
  validates :name, presence: true

end
