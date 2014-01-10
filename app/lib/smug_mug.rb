require "net/https"
require "uri"
require 'rest_client'

class SmugMug
  attr_accessor :smug
  
  HOST = 'api.smugmug.com/services/api/json/1.2.2/'
  
  def initialize
    # @smug = Smirk::Client.new("rana@thedailybaby.com", "gheissari")
  end
  
  def get_urls(image_id, image_key, password)
    params = { 
      :method => "smugmug.login.withPassword", 
      :APIKey => '6o6SLvwiAs6MAsCGMQ4VoeKzggC7Whap', 
      :EmailAddress => 'rana@thedailybaby.com', 
      :Password => 'gheissari'
    }
    session_id = get(params, true)['Login']['Session']['id']
#     
    # params = { 
      # :method => "smugmug.images.getURLs", 
      # :SessionID => session_id, 
      # :ImageID => image_id, 
      # :ImageKey => image_key
    # }
    params[:SessionID] = session_id
    params[:method] = "smugmug.images.getURLs"
    params[:ImageID] = image_id
    params[:ImageKey] = image_key
    params[:Password] = password
    puts get(params, true)
  end
  
  def put_resource(album_id, filename, content, caption)
    params = { 
      :method => "smugmug.login.withPassword", 
      :APIKey => '6o6SLvwiAs6MAsCGMQ4VoeKzggC7Whap', 
      :EmailAddress => 'rana@thedailybaby.com', 
      :Password => 'gheissari'
    }
    session_id = get(params, true)['Login']['Session']['id']
    
    uri = URI.parse('http://upload.smugmug.com/')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(
      uri.path, 
      initheader = 
        {
          'X-Smug-AlbumID' => album_id.to_s,
          'X-Smug-SessionID'  => session_id,
          'X-Smug-Version' => '1.2.2',
          'X-Smug-FileName' => filename,
          'X-Smug-Caption' => caption,
          'X-Smug-ResponseType' => 'JSON'
        }
      )
    req.body = content
    res = http.request(req)
    JSON.parse(res.body)
    # RestClient.post 'http://upload.smugmug.com/', 
    # {
      # :AlbumID => album_id,
      # :SessionID => session_id,
      # :Version => '1.2.2',
      # :myfile => content
    # }
#     
    # request = RestClient::Request.new(
          # :method => :post,
          # :url => '/data',
          # :user => @sid,
          # :password => @token,
          # :payload => {
            # :multipart => true
            # :file => File.new("/path/to/image.jpg", 'rb')
          # })      
    # response = request.execute

    # http = Net::HTTP.new('www.mywebsite.com', port)
    # response = http.send_request('PUT', '/path/from/host?id=id&option=enable|disable')
# 
    # # allow duplicate file names for a service and tag - use external id for that
    # object = @bucket.objects.build(s3_name)
    # object.content = content
    # object.save
    # object
  end
  
  private
  
  def get(params = {}, ssl = false)
    proto = ssl ? "https://" : "http://"
    JSON.parse(RestClient.post(proto+HOST, params).body)
  end
  
end