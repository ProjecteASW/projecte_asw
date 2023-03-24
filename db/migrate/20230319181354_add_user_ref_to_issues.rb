class AddUserRefToIssues < ActiveRecord::Migration[7.0]
  def change
    add_reference :issues, :user, null: false, foreign_key: true
  end
end
