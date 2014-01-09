class UserSmsNotifier
  Fattr( :default_twilio_klass ){ Twilio::REST::Client }
  fattr( :twilio_klass ){ self.class.default_twilio_klass }

  def upload_reminder( parent )
    return false if invalid_parent?( parent )

    messages.create \
      :from => TWILIO_NUMBER,
      :to   => parent.cell_phone,
      :body => body_for( parent )
  end

  private

  def body_for( parent )
    "Don't forget to send a picture of #{ kid_name_for parent } to #{ upload_email }"
  end

  def client
    @_client =
      twilio_klass.new \
        TWILIO_ACCOUNT_SID,
        TWILIO_AUTH_TOKEN
  end

  def invalid_parent?( parent )
    ! valid_parent?( parent )
  end

  def kid_name_for( parent )
    kid_name =   parent.kids.map( &:name ).detect &:present?
    kid_name ||= 'your child'
    kid_name
  end

  def messages
    client.account.messages
  end

  def upload_email
    'upload@gallery.thedailybaby.com'
  end

  def valid_parent?( parent )
    parent.cell_phone.present?
  end
end
