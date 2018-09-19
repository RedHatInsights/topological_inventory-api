class Source < ApplicationRecord
  has_many :endpoints, :dependent => :destroy
end
