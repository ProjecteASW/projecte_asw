class Tag < ApplicationRecord
  belongs_to :issue, dependent: :destroy
  validates :name, presence: true

end
