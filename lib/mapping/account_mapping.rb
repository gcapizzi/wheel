require_relative '../account'
require_relative '../mapping'

module Scrooge

  class AccountMapping < Mapping
    maps Account
    fields :name
  end

end
