class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.text :table
      t.string :state
      t.string :turn
      t.string :winner
      t.boolean :myTurn

      t.timestamps
    end
  end
end
