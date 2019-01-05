class KeywordTagging < ApplicationRecord
  belongs_to :keyword
  belongs_to :tag
end
