class WatchedIssueIssueSerializer < ActiveModel::Serializer
    attributes :profile_id, :profile


    def profile
        object.user.username
    end

    def profile_id
        object.user.id
    end

  end