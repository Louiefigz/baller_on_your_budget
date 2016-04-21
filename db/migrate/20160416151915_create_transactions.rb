class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :lender_id
      t.integer :borrower_id

      t.integer :amount,  default: 0
      t.boolean :lending, default: true

      t.timestamps null: false
    end
  end
end
