#ActionMailer::Base.smtp_settings = {
#  :address              => "smtp.sendgrid.com",
#  :port                 => 587,
#  :domain               => "dailybaby.com",
#  :user_name            => "robdelwo",
#  :password             => "sgtdb22413",
#  :authentication       => "plain",
#  :enable_starttls_auto => true
#}

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :domain               => "thedailybaby.com",
  :user_name            => "robdelwo",
  :password             => "sgtdb22413",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] =
  case Rails.env
  when 'production'
    'thedailybaby.com'
  else
    'localhost:3000'
  end

if Rails.env.development?
  DEVELOPMENT_EMAIL =
    ( ENV[ 'DEVELOPMENT_EMAIL' ] or 'dev@thedailybaby.local' )

  Mail.register_interceptor(DevelopmentMailInterceptor)
end
