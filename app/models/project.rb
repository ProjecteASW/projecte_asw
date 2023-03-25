class Project < ApplicationRecord
    belongs_to :user
    has_many :issues
    has_many :memberships
  has_many :users, through: :memberships
  end
  