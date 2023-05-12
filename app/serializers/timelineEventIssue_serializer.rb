class TimelineEventIssueSerializer < ActiveModel::Serializer
    attributes :profile_id, :profile, :message, :date


    def profile
        object.user.username
    end

    def profile_id
        object.user.id
    end

    def date
        (object.created_at + Time.parse("02:00:00").seconds_since_midnight.seconds).strftime('%H:%M - %d/%m/%Y')
    end

  end