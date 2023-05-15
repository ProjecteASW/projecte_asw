class IssueSerializer < ActiveModel::Serializer
    attributes :id, :subject, :description, :status, :created_by_user_id, :created_by_user_username, :creation_date, :issue_type, :severity, :priority, :limitDate, :blocked, :assigned_profile_id, :assigned_profile_username, :watchers, :attachments, :activities

    has_many :comments, serializer: CommentSerializer

    def assigned_profile_id
        object.assigned_to_id
    end

    def assigned_profile_username
        User.find(object.assigned_to_id).username
    end

    def created_by_user_id
        object.user_id
    end

    def created_by_user_username
        object.user.username
    end

    def creation_date
        (object.created_at + Time.parse("02:00:00").seconds_since_midnight.seconds).strftime('%H:%M - %d/%m/%Y')
    end
    
    def watchers
        ActiveModel::Serializer::CollectionSerializer.new(object.watched_issue, serializer: WatchedIssueIssueSerializer)
    end

    def attachments
        ActiveModel::Serializer::CollectionSerializer.new(object.files, serializer: AttachmentSerializer)
    end

    def activities
        ActiveModel::Serializer::CollectionSerializer.new(object.timeline_events, serializer: TimelineEventIssueSerializer)
    end
end