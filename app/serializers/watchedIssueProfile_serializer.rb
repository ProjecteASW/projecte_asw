class WatchedIssueProfileSerializer < ActiveModel::Serializer
    attributes :project_id, :project, :issue_id, :issue

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

  end