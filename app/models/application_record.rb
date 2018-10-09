class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def as_json(options = nil)
    super.tap { |h| h["id"] = h["id"].to_s }
  end
end
