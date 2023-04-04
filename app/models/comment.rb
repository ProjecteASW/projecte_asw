class Comment < ApplicationRecord
    
    belongs_to :issue, dependent: :destroy
    belongs_to :user, dependent: :destroy
  
  end
  