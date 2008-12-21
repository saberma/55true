#hack selenium to use spec fixture
module SeleniumOnRails
  module Paths
    def fixtures_path
      File.expand_path File.join(RAILS_ROOT, '/spec/fixtures/')
    end
  end
end