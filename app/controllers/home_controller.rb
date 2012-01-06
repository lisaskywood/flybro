class HomeController < ApplicationController
  respond_to :js, :html
  
  def index
  end
  
  def mail
    if params[:username].present? && params[:email].present? && params[:content].present?
      MessageMailer.from(params[:username], params[:email], params[:content]).deliver
      flash.now.notice = t('mail.sent')
    else
      flash.now.notice = t('mail.missing')
      render :error
    end
  end
end
