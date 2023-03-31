class CreateWatchedIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :watched_issues do |t|
      t.references :user, foreign_key: true, null: false
      t.references :issue, foreign_key: true, null: false

      t.timestamps
    end
  end
end
