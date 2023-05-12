class TimelineEventSerializer < ActiveModel::Serializer
    attributes :project, :issue, :profile, :message, :date

    def project
        object.issue.project.id.to_s + " - " + object.issue.project.name.to_s
    end

    def issue
        object.issue.id.to_s + " - " + object.issue.subject.to_s
    end

    def profile
        object.user.username
    end

    def date
        (object.created_at + Time.parse("02:00:00").seconds_since_midnight.seconds).strftime('%H:%M - %d/%m/%Y')
    end

  end