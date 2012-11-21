require 'sequel/core'
require_relative '../account'
require_relative '../mapping'

module Scrooge
  class AccountMapping < Mapping
    @klass = Account
    @fields = [:name]
  end
end
