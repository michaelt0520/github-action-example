# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string  :display_name, null: false
      t.string  :email, null: false, unique: true
      t.string  :role, null: false, default: 'member'

      t.timestamps
    end
  end
end
