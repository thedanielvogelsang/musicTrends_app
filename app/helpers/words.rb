require_relative '../../lib/datapoints'

#used to house words and downcase Faker words from datapoints.rb
module Words
  module CommonWords
    WORDS = [
      'a',
      'an',
      'to',
      'the',
      'and',
      'yet',
      'but',
      'of',
      'as',
      'is',
      'be',
      'of',
      'that',
      'have',
      'on',
      'do',
      'you',
      'me',
      'with',
      'this',
      'they',
      'from',
      'by',
      'so',
      'in',
      'out',
    ]
  end
  module Products
    PRODUCTS = Datapoints::FakerData.products.map{|p| p.downcase}
  end
  module Buzzwords
    BUZZWORDS = Datapoints::FakerData.buzzwords.map{|p| p.downcase}
  end
end
