class IssueSerializer < ActiveModel::Serializer
    attributes :id, :subject, :description, :status, :created_by_user_id, :created_at, :issue_type, :severity, :priority, :limitDate, :blocked, :assigned_profile

    has_many :timeline_events, serializer: TimelineEventIssueSerializer
    has_many :watched_issues, serializer: WatchedIssueIssueSerializer

    def assigned_profile
        object.assigned_to_id
    end

    def created_by_user_id
        object.user_id
    end
end