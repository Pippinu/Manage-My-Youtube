class RemoveLocalPasswordFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :local_password, :string
  end
end
