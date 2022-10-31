class AddAziendaToAffiliations < ActiveRecord::Migration[7.0]
  def change
    add_column :affiliations, :azienda, :string
  end
end
