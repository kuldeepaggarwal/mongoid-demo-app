class UserMailer < ActionMailer::Base
  default from: "<kuldeep.aggarwal@vinsol.com>"
  def welcome_email(user)
    @user = user
    @url  = "http://vinsol.com"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Welcome to My Gadget Store")
  end
  def welcome
    attachments.inline['image.jpg'] = File.read('/path/to/image.jpg')
  end
end
