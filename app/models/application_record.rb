class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_by_id_or_create(id, &block)
    obj = self.find_by_id( id ) || self.new
    yield obj
    obj.save
  end
end
