class AddRuoloToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :ruolo, :string
  end
end
