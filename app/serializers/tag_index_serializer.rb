class TagIndexSerializer < ActiveModel::Serializer
  attributes :id, :context, :key_words, :keywords


      def keyword
        object.keywords.pluck(:id, :phrase)
      end

end
