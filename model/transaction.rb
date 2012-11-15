module Scrooge

  class Transaction
    attr_accessor :id, :description, :amount

    def initialize(description = '', amount = 0)
      @description = description
      @amount = amount
    end
  end

end
