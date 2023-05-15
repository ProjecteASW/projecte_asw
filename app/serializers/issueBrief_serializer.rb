class IssueBriefSerializer < ActiveModel::Serializer
    attributes :id, :subject, :status, :creation_date, :issue_type, :severity, :priority, :blocked, :assigned_profile_id, :assigned_profile_username

    def assigned_profile_id
        object.assigned_to_id
    end

    def assigned_profile_username
        User.find(object.assigned_to_id).username
    end
    
    def creation_date
        (object.created_at + Time.parse("02:00:00").seconds_since_midnight.seconds).strftime('%H:%M - %d/%m/%Y')
    end
end