class SmugMugWrapper
  attr_accessor :client
  
  # TODO put into config file before before pushing to git
  API_KEY = '6o6SLvwiAs6MAsCGMQ4VoeKzggC7Whap'
  OAUTH_SECRET = 'eacb5d5602e860e4805e04f338e34cba'
  OAUTH_TOKEN = '29e2c52aa9543387face3634a7c630c5'
  OAUTH_TOKEN_SECRET = '3ca4a25be8fabeeb917bc74cc85b3f2afd3267041b603af977523ee61a874670'
  
  def initialize
    # @client = SmugMug::Client.new(
      # :api_key => API_KEY,
      # :oauth_secret => OAUTH_SECRET, 
      # :user => {
        # :token => OAUTH_TOKEN, 
        # :secret => OAUTH_TOKEN_SECRET
      # }
    # )
    @client = Smirk::Client.new("rana@thedailybaby.com", "gheissari")
  end
  
  def get_albums
    @client.albums
  end
  
  def get_image_url(image_id, image_key, password=nil)
    @client.find_image(image_id, image_key).originalurl
  end
  
end