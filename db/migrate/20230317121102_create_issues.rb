class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.string :subject, null: false
      t.text :description
      t.integer :issue_type
      t.integer :severity
      t.integer :priority
      t.integer :status
      t.date :limitDate
      t.boolean :blocked, default: false # Añade el atributo booleano "blocked" con valor por defecto "false"
      t.timestamps
    end
  end
end
