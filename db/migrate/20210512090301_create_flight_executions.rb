# frozen_string_literal: true

class CreateFlightExecutions < ActiveRecord::Migration[6.1]
  def change
    create_table :flight_executions do |t|
      t.belongs_to :airplane
      t.belongs_to :flight
      t.integer :passengers_count, null: false, default: 0
      t.datetime :start_time, null: false

      t.timestamps

      t.index :start_time
    end
  end
end
