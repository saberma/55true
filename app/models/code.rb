class Code
  include Mongoid::Document
  referenced_in :user

  field :code

  def self.random
    rand(36**6).to_s(36)
  end
end
