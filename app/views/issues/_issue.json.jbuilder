json.extract! issue, :id, :subject, :description, :issue_type, :severity, :priority, :limitDate, :created_at, :updated_at
json.url issue_url(issue, format: :json)
