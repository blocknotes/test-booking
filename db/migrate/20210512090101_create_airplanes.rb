# frozen_string_literal: true

class CreateAirplanes < ActiveRecord::Migration[6.1]
  def change
    create_table :airplanes do |t|
      t.string :reference, null: false
      t.string :model, null: false
      t.integer :max_passengers, null: false, default: 0

      t.timestamps
    end
  end
end
