class DeleteHashColumnCalendar < ActiveRecord::Migration[7.0]
  def change
    remove_column :calendars, :hash
  end
end
