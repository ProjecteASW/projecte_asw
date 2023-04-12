class AddAssignedToToIssues < ActiveRecord::Migration[7.0]
  def change
    add_reference :issues, :assigned_to, foreign_key: { to_table: :users }, null: true
  end
end