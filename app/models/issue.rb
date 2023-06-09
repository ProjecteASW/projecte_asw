class Issue < ApplicationRecord

  validates :subject, presence: true
    enum issue_type: { bug: 0, question: 1, enhancement: 2 },_default: 0
    enum severity: { wishlist: 0, minor: 1, norm: 2, important: 3, critical: 4},_default: 0
    enum status: { open: 0, in_progress: 1, testing: 2, reopened: 3, resolved: 4 }, _default: 0
    enum priority: { low: 0, normal: 1, high: 2 },_default: 0
    belongs_to :project, dependent: :destroy
    belongs_to :user, dependent: :destroy
    belongs_to :assigned_to, class_name: 'User', foreign_key: 'assigned_to_id'
    has_many :tags, dependent: :destroy
    has_many :watched_issue, dependent: :destroy
    has_many :timeline_events, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many_attached :files, dependent: :destroy
    def update_status(params)
        update(status: params[:status])
    end
end
