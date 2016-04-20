class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :amount, default: 0
      t.integer :borrower_id
      t.integer :lender_id

      t.timestamps null: false
    end
  end
end
