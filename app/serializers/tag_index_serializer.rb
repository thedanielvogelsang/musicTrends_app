class TagIndexSerializer < ActiveModel::Serializer
  attributes :id, :context, :key_words, :keywords
  
end
