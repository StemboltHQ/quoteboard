class MigrateDataFromQuotesQuotedPersonToPerson < ActiveRecord::Migration
  Quote.all.each do |quote|
    quote.update(person: Person.find_or_create_by(full_name: quote.quoted_person)) if quote.quoted_person
  end
end
