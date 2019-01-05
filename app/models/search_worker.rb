class SearchWorker
  include Words
  attr_reader :search_id, :refs

  def initialize(search_id)
    @search_id = Search.find(search_id).id
    rescue ActiveRecord::RecordNotFound => e
        raise ArgumentError, 'Argument is not numeric'
    @refs = nil 
  end

end
