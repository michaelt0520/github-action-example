# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.bigint :user_id, null: false
      t.string :name,    null: false, unique: true
      t.string :bank,    null: false

      t.timestamps
    end

    add_index :accounts, %i[user_id name bank], unique: true
  end
end
