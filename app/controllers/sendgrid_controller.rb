class SendgridController < ApplicationController
  respond_to :json
  protect_from_forgery except: :create
  
  #  Parameters: {"headers"=>"Received: by mx2.sendgrid.net with SMTP id 9rTRqnsdUw Thu, 10 Oct 2013 02:56:05 +0000 (UTC)\nReceived: from mail-pd0-f171.google.com (mail-pd0-f171.google.com [209.85.192.171]) by mx2.sendgrid.net (Postfix) with ESMTPS id 67ECF1789416 for <test@sendgrid.thedailybaby.com>; Thu, 10 Oct 2013 02:55:58 +0000 (UTC)\nReceived: by mail-pd0-f171.google.com with SMTP id g10so1904670pdj.16 for <test@sendgrid.thedailybaby.com>; Wed, 09 Oct 2013 19:55:58 -0700 (PDT)\nX-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net; s=20130820; h=x-gm-message-state:mime-version:date:message-id:subject:from:to :content-type; bh=G80MVMeK8+wjy1pJMxbiY/jwr/EVmfZjNueOuKKu+Kg=; b=akmI2hu2tNQt4TDNlP8tXvwa0DtbWENadJlDQo7FeOpsLh6cDi4E+10RYgoGv7mk4o ZocLWUx1+firHVEMZMB1nulsJw5NhjEE7mC5hqtbQ28xWEbByA8TkpBk0gh3juXUlz08 on11GgSGYruxz0A+b6ycIitrsMstxvNOz/jo5fIjp1V7e7vOC14DSRsB5lkIhVehR/Pl EzigRQGb4aWYg3Gh5nUSvUIjnVYfzVQ/Rv0PVXbGts1bwHgzoTQedbmPltXALYC2UILN Kur5J0ZdExCFtlm4IySZNicsKePZGajtOP3DlYAF1WdQE79h7MzOuy5etRT0EPc3yq0a flJg==\nX-Gm-Message-State: ALoCoQn+iM/TYbG0vPwLpYqF+lQVRAxebH3zWALuAHsnbeJXYXOcYKopvp5Y7HikTfRXMJrUjHkP\nMIME-Version: 1.0\nX-Received: by 10.66.11.202 with SMTP id s10mr13127762pab.86.1381373758070; Wed, 09 Oct 2013 19:55:58 -0700 (PDT)\nReceived: by 10.68.29.166 with HTTP; Wed, 9 Oct 2013 19:55:57 -0700 (PDT)\nDate: Wed, 9 Oct 2013 20:55:57 -0600\nMessage-ID: <CAKSkT3XFBwyyXG8NdgN+KUNfXh=+zgKE1z+tMzHgr+T4EoDkJw@mail.gmail.com>\nSubject: test\nFrom: Kevin Cawley <kcawley@birdbox.com>\nTo: test@sendgrid.thedailybaby.com\nContent-Type: multipart/mixed; boundary=bcaec520f30527b71004e85a24a7\n", "attachments"=>"1", "dkim"=>"none", "subject"=>"test", "to"=>"test@sendgrid.thedailybaby.com", "attachment-info"=>"{\"attachment1\":{\"filename\":\"porter.jpg\",\"name\":\"porter.jpg\",\"type\":\"image/jpeg\"}}", "html"=>"<div dir=\"ltr\"><br clear=\"all\"><div><br></div>-- <br>#kcbigring\r\n</div>\n", "from"=>"Kevin Cawley <kcawley@birdbox.com>", "text"=>"-- \r\n#kcbigring\n", "sender_ip"=>"209.85.192.171", "attachment1"=>#<ActionDispatch::Http::UploadedFile:0x00000003de23c8 @tempfile=#<File:/tmp/RackMultipart20131009-27376-s1vn3h>, @original_filename="porter.jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"attachment1\"; filename=\"porter.jpg\"\r\nContent-Type: image/jpeg\r\n">, "envelope"=>"{\"to\":[\"test@sendgrid.thedailybaby.com\"],\"from\":\"kcawley@birdbox.com\"}", "charsets"=>"{\"to\":\"UTF-8\",\"html\":\"ISO-8859-1\",\"subject\":\"UTF-8\",\"from\":\"UTF-8\",\"text\":\"ISO-8859-1\"}", "SPF"=>"pass"}

  def create
    begin
      email = Mail::AddressList.new(params['from']).addresses.first.address.downcase
      parent = Parent.find_by_email(email)
      Rails.logger.debug ">>>> User uploading file #{parent.inspect}"
      
      if parent
        params['attachments'].to_i.times do |i|
          Rails.logger.debug ">>>> Filename #{params["attachment#{i+1}"].original_filename}"
          stream = params["attachment#{i+1}"]
          subject = params['subject'].to_s.strip
          caption = params['text'].to_s.strip
          caption = "#{subject}: #{caption}" if subject.length > 0
          parent.upload(params["attachment#{i+1}"].original_filename, stream.read, caption)
        end
      end
    rescue Exception => exc
      Rails.logger.error "Failed uploading form email #{exc.message}"
    end
    render :status => 200, :nothing => true
  end
  
  def index
    render :status => 200, :nothing => true
  end
  
end
