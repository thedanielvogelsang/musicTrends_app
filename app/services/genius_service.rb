class GeniusService
  attr_reader :conn

  def initialize
    @conn = Faraday.new(url: "https://api.genius.com/oauth/authorize") do |f|
      f.adapter Faraday.default_adapter
    end
  end

  def get_songs(query)
  resp = @conn.get '/search' do |req|
    req.headers['User-Agent'] = 'CompuServe Classic/1.22'
    req.headers['Accept'] = 'application/json'
    req.headers['Host'] = 'api.genius.com'
    req.headers['Authorization'] = "Bearer " + ENV['ACCESS_TOKEN']
    req.params['q'] = query
    req.params["per_page"] = 50
  end
  return JSON.parse(resp.body, symbolize_names: true)[:response][:hits].map{|s| s[:result] }
end
end
