class CreateVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.timestamps
    end

    add_index :votes, [:user_id, :option_id], unique: true
  end
end
