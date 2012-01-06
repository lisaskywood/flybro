class HomeController < ApplicationController
  def index
  end
  
  def mail
    MessageMailer.from(params[:name], params[:email], params[:content]).deliver
  end
end
