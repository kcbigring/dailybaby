class ScheduledEmailsController < ApplicationController
  
  def index
    @scheduled_emails = ScheduledEmail.paginate(:page => params[:page], :per_page => 1).order(:created_at => :desc)
  end

end
