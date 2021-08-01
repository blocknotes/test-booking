# frozen_string_literal: true

class CreateFlights < ActiveRecord::Migration[6.1]
  def change
    create_table :flights do |t|
      t.string :from_city, null: false
      t.string :to_city, null: false
      t.integer :duration # in minutes

      t.timestamps

      t.index %i[from_city to_city], unique: true
    end
  end
end
