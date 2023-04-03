class Project < ApplicationRecord
    belongs_to :user, dependent: :destroy
    has_many :issues, dependent: :destroy
    has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships, dependent: :destroy
  end
  