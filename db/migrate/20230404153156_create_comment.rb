class CreateComment < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, null: false
      t.references :issue, foreign_key: true, null: false
      t.string :text

      t.timestamps
    end
  end
end
