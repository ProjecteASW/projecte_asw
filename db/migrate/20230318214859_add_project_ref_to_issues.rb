class AddProjectRefToIssues < ActiveRecord::Migration[7.0]
  def change
    add_reference :issues, :project, null: false, foreign_key: true
  end
end
