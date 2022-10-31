class CreateAffiliations < ActiveRecord::Migration[7.0]
  def change
    create_table :affiliations do |t|
      t.string :cliente
      t.string :manager
      t.string :status

      t.timestamps
    end
  end
end
