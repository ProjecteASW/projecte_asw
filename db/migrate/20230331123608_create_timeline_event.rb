class CreateTimelineEvent < ActiveRecord::Migration[7.0]
  def change
    create_table :timeline_events do |t|
      t.references :user, foreign_key: true, null: false
      t.references :issue, foreign_key: true, null: false
      t.timestamps
    end
  end
end
