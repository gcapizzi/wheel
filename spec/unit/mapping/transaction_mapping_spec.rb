require 'spec_helper'

module Scrooge
  describe TransactionMapping do
    let(:record) { { description: "Test transaction", amount: 12.34 } }
    let(:saved_record) { record.merge(id: 1) }
    let(:transaction) { t = Transaction.new("Test transaction", 12.34); t.id = 1; t }
    let(:mapping) { TransactionMapping.new }

    describe '#from_record' do
      it 'builds a Transaction instance from a hash' do
        mapped_transaction = mapping.from_record(saved_record)

        mapped_transaction.should be_instance_of Transaction
        mapped_transaction.id.should == 1
        mapped_transaction.description.should == "Test transaction"
        mapped_transaction.amount.should == 12.34
      end
    end

    describe '#to_record' do
      it 'builds a hash from an Transaction instance' do
        mapping.to_record(transaction).should == record
      end
    end
  end
end
