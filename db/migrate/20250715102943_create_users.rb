class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :google_image_url

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, [ :provider, :uid ], name: "index_users_on_uid_and_provider", unique: true
  end
end
