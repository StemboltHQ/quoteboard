class AddPersonReferenceToQuotes < ActiveRecord::Migration
  def change
    add_reference :quotes, :person, index: true, foreign_key: true
  end
end
