require_relative '../../lib/datapoints'

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
    ]
  end
  module Products
    PRODUCTS = Datapoints::FakerData.products
  end
end