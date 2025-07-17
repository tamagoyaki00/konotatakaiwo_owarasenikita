class CreateOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :options do |t|
      t.timestamps
    end
  end
end
