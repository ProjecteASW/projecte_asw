class ChangeAssignedToNullConstraint < ActiveRecord::Migration[7.0]
  def change
    change_column_null :issues, :assigned_to_id, false
  end
end
