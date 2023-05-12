class UserSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    attributes :id, :email, :username, :bio, :profile_picture

    has_many :timeline_events, serializer: TimelineEventProfileSerializer
    has_many :watched_issues, serializer: WatchedIssueProfileSerializer

    def profile_picture
        if object.avatar.attached?
            Rails.application.routes.url_helpers.rails_blob_path(object.avatar, only_path: true, disposition: "attachment")
        else
            ""
        end
    end
end