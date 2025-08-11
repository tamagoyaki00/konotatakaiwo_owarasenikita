class CreateOpinionReactions < ActiveRecord::Migration[7.2]
  def change
    create_table :opinion_reactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :opinion, null: false, foreign_key: true
      t.timestamps
    end

    add_index :opinion_reactions, [ :user_id, :opinion_id ], unique: true
  end
end
