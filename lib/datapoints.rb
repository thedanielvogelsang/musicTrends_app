require 'faker'

module Datapoints
  class FakerData
    def self.products
      products = Array.new
      10.times{products.push(Faker::Appliance.brand)}
      10.times{products.push(Faker::App.name)}
      10.times{products.push(Faker::Device.model_name)}
      10.times{products.push(Faker::Device.manufacturer)}
      return products.uniq
    end
    def self.buzzwords
      products = Array.new
      products.push("sexual")
      90.times{products.push(Faker::Hipster.word)}
      return products.uniq
    end
  end
end
