class UserBoard < ActiveRecord::Migration[6.1]
  def change
    create_table :users_boards do |t|
      t.belongs_to :user
      t.belongs_to :board
    
      t.timestamps
    end
    
  end
end
