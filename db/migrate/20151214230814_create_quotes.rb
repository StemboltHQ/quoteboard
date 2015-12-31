class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :author
      t.text :body
      t.string :location
      t.timestamps null: false
    end
  end
end
