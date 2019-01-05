class GeniusService
  attr_reader :conn

  def initialize
    @conn = Faraday.new(url: "https://api.genius.com/oauth/authorize") do |f|
      f.adapter Faraday.default_adapter
      f.headers['User-Agent'] = 'CompuServe Classic/1.22'
      f.headers['Accept'] = 'application/json'
      f.headers['Host'] = 'api.genius.com'
      f.headers['Authorization'] = "Bearer " + ENV['ACCESS_TOKEN']
    end
  end

  def get_songs(query)
    resp = @conn.get '/search' do |req|
      req.params['q'] = query
      req.params["per_page"] = 50
    end
    return JSON.parse(resp.body, symbolize_names: true)[:response][:hits].map{|s| s[:result] }
  end

  def get_song_info(id)
    resp = @conn.get "/songs/#{id}" do |req|
      req.params["per_page"] = 50
    end
    if JSON.parse(resp.body, symbolize_names: true)[:response]
      return JSON.parse(resp.body, symbolize_names: true)[:response][:song]
    else
      return nil
    end
  end

  def get_referents(id)
    resp = @conn.get "/referents" do |req|
      req.params["song_id"] = id
    end
    resp = JSON.parse(resp.body, symbolize_names: true)
    if !resp[:response][:referents].empty?
      return resp[:response][:referents]
    else
      return nil
    end
  end
end
