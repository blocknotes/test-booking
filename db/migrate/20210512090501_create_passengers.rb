# frozen_string_literal: true

class CreatePassengers < ActiveRecord::Migration[6.1]
  def change
    create_table :passengers do |t|
      t.belongs_to :flight_execution
      t.belongs_to :user

      t.timestamps
    end
  end
end
