class AwsStore
  attr_accessor :aws, :bucket

  def initialize(bucket_name=nil)
    # config = APP_CONFIG['storage']['aws']
    # settings = {:access_key_id => config['access_key_id'], :secret_access_key => config['secret_access_key']}
    settings = {:access_key_id => 'AKIAILFNUEQSJPG5QBXQ', :secret_access_key => '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'}
    @aws = S3::Service.new(settings)
    if bucket_name
      @bucket = @aws.buckets.find(bucket_name)
      if !@bucket
        @bucket = @aws.buckets.build(bucket_name)
        @bucket.save
      end
    end
  end

  def list_old(prefix)
    @bucket.objects(:prefix => prefix)
  end
  
  def list(prefix)
    @bucket.objects(:prefix => "service/#{prefix}/")
  end
  
  def put_resource(s3_name, content)
    # allow duplicate file names for a service and tag - use external id for that
    object = @bucket.objects.build(s3_name)
    object.content = content
    object.save
    object
  end
  
  def resource_exists?(name, filter='')
    object = nil
    filter += '/' if filter.length > 0
    begin
      object = bucket.objects.find("#{filter}#{name}")
    rescue
    end
    object
  end
  
  def destroy_resource(name, filter='')
    filter += '/' if filter.length > 0
    object = bucket.objects.find("#{filter}#{name}") if resource_exists?(name, filter)
    object.destroy if object
  end
  
  def get_content(name, filter='')
    ret = nil
    filter += '/' if filter.length > 0
    object = bucket.objects.find("#{filter}#{name}")
    ret = object.content
    ret ||= object.content(true)
    ret
  end

end