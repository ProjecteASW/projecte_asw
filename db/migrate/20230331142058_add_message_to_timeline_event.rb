class AddMessageToTimelineEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :timeline_events, :message, :string, default: ''
  end
end
