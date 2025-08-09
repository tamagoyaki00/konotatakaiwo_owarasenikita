class RemoveOptionFromOpinions < ActiveRecord::Migration[7.2]
  def change
    remove_reference :opinions, :option, null: false, foreign_key: true, index: true
  end
end
