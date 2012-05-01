class MessageMailer < ActionMailer::Base
  def from(name, email, content)
    @content = content
    mail(
      :from    => "#{name} <#{email}>", 
      :to      => "feige@ucheke.com", 
      :subject => "Someone left a message for you")
  end
end
