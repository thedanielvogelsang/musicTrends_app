class TrendService
  attr_reader :conn

  def initialize(type_of_hash, hsh_info)
    @type = type_of_hash
    @hsh_info = hsh_info
    @id = hsh_info['id']
    @conn = Aws::S3::Client.new(
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
      region: ENV['S3_REGION'],
    )
  end

  def log_song_trends
    body = build_puts_body
    # open("db/seeds.rb", 'a') do |f|
    #   f.puts([@hsh_info['id'], @hsh_info['title'], @hsh_info['artist_name']])
    #   f.print("\n  ^ SONG ^ \n")
    # end
    byebug
    obj_name = "logs/songs/#{s_name}/#{@hsh_info['title']}-#{DateTime.now.strftime("%Y-%m-%d %H:%M:00s").to_s}"
    put_object(obj_name, body)
  end

  def log_tag_trends
    body = build_puts_body
    # open("db/seeds.rb", "a") do |f|
    #   f.puts([@hsh_info['context'], @hsh_info['key_words']])
    #   f.print("\n ^ TAG ^ \n")
    # end
    obj_name = "logs/tags/#{@hsh_info['context']}-#{DateTime.now.strftime("%Y-%m-%d %H:%M:00s").to_s}"
    put_object(obj_name, body)
  end

  def build_puts_body
    @hsh_info.map{|k, v| v}.to_a.join(',') + "\n"
  end

  def put_object(obj_name, body)
    @conn.put_object({
        bucket: ENV["S3_BUCKET"],
        key: obj_name,
        body: body,
      })
  end

  def s_name
    @hsh_info['artist_name']
  end
end
