class TrendService
  attr_reader :conn

  def initialize(type_of_hash, hsh_info)
    @type = type_of_hash
    @hsh_info = hsh_info
    @conn = Aws::S3::Client.new(
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
      region: ENV['S3_REGION'],
    )
  end

  def log_song_trends
    body = []
    body.push(@hsh_info.to_a.join(',').strip)
    return body
  end
end
