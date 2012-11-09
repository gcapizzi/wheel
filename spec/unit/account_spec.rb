require 'rspec'
require_relative '../../model/account'

module Scrooge
  describe Account do
    it 'is empty by default' do
      account = Account.new
      account.name.should == ''
      account.should be_empty
    end

    describe '#initialize' do
      it 'sets the account name' do
        account = Account.new('Wallet')
        account.name.should == 'Wallet'
      end
    end

    describe '#add' do
      it 'adds a transaction' do
        account = Account.new
        transaction = Transaction.new('a transaction', 10)
        account.add transaction
        account.last.should == transaction
      end
    end
  end
end
