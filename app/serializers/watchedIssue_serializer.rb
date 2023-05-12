class WatchedIssueSerializer < ActiveModel::Serializer
    attributes :project, :issue, :profile

    def project
        object.issue.project.id.to_s + " - " + object.issue.project.name.to_s
    end

    def issue
        object.issue.id.to_s + " - " + object.issue.subject.to_s
    end

    def profile
        object.user.username
    end

  end