# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.bigint  :account_id,           null: false
      t.decimal :amount, default: 0.0, null: false
      t.string  :transaction_type,     null: false

      t.timestamps
    end

    add_index :transactions, :account_id
  end
end
