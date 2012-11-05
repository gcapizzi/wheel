module Scrooge

  class Account
    attr :name
    attr_reader :transactions

    def initialize(name = '')
      @name = name
      @transactions = []
    end

    def empty?
      @transactions.empty?
    end

    def add(transaction)
      @transactions << transaction
    end

    def last
      @transactions.last
    end
  end

end
