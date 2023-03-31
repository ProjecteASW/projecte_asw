class Issue < ApplicationRecord

  validates :subject, presence: true
    enum issue_type: { bug: 0, question: 1, enhancement: 2 }
    enum severity: { wishlist: 0, minor: 1, norm: 2, important: 3 }
    enum status: { open: 0, in_progress: 1, testing: 2, reopened: 3, resolved: 4 }, _default: 0
    enum priority: { low: 0, normal: 1, high: 2 }
    belongs_to :project
    belongs_to :user
    has_many :tags
    has_many :watched_issue
    def update_status(params)
        update(status: params[:status])
    end
end
