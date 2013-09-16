class AddCalEventIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :cal_event_id, :string
  end
end
