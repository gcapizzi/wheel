require 'rspec'
require_relative '../../model/transaction_mapper'

module Scrooge
  describe TransactionMapper do
    let(:dataset) {
      db = Sequel.sqlite
      db.create_table :transactions do
        primary_key :id
        String :description
        BigDecimal :amount, size: [10, 2]
      end
      db[:transactions]
    }
    let(:mapper) { TransactionMapper.new(dataset) }
    let(:transaction) { Transaction.new("Test transaction", 12.34) }

    describe '#save' do
      it 'saves an account successfully' do
        mapper.save(transaction)
        found = mapper.find(id: transaction.id)
        found.description.should == transaction.description
      end

      it 'updates an account successfully' do
        mapper.save(account)
        account.name = "Test account new name"
        mapper.save(account)
        found = mapper.find(id: account.id)
        found.name.should == account.name
      end
    end
  end
end
