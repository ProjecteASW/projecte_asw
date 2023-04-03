class Membership < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :project, dependent: :destroy
end
