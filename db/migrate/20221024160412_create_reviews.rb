class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string :reviewer
      t.string :reviewed
      t.integer :stars
      t.string :testo

      t.timestamps
    end
  end
end
