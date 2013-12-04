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

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?