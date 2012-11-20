require 'spec_helper'
require_relative '../../lib/transaction'

module Scrooge
  describe Transaction do
    it 'is empty by default' do
      transaction = Transaction.new
      transaction.description.should == ''
      transaction.amount.should == 0
    end

    describe '#initialize' do
      it 'sets description and amount' do
        description = 'a new transaction'
        amount = 10
        transaction = Transaction.new(description, amount)
        transaction.description.should == description
        transaction.amount.should == amount
      end
    end
  end
end
