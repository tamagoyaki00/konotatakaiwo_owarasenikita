class CreateOpinions < ActiveRecord::Migration[7.2]
  def change
    create_table :opinions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.text :content, null: false
      t.timestamps
    end

    add_index :opinions, [ :user_id, :question_id ]
  end
end
