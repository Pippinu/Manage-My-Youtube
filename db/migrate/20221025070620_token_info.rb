class TokenInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :access_token, :string
    add_column :users, :refresh_token, :string
  end
end