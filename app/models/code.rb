class Code
  include Mongoid::Document
  referenced_in :user
end
