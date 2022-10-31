class EventDb < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :summary
      t.string :description
      t.date :start
      t.date :end
      t.string :calendarID
      t.string :eventID
      t.string :clientID
      t.string :managerID

      t.timestamps
    end
    
  end
end
