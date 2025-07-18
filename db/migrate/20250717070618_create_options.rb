class CreateOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :options do |t|
      t.string :content, null: false
      t.references :question, null: false, foreign_key: true
      t.timestamps
    end
  end
end
