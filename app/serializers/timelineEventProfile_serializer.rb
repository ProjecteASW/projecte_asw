class TimelineEventProfileSerializer < ActiveModel::Serializer
    attributes :project_id, :project, :issue_id, :issue, :message, :date

    def project_id
        object.issue.project.id
    end

    def project
        object.issue.project.name
    end

    def issue_id
        object.issue.id
    end

    def issue
        object.issue.subject
    end

    def date
        (object.created_at + Time.parse("02:00:00").seconds_since_midnight.seconds).strftime('%H:%M - %d/%m/%Y')
    end

  end