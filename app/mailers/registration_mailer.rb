class RegistrationMailer < ActionMailer::Base

  default from: "no-reply@jbox-web.com"

  def welcome(user, password)
    @user     = user
    @password = password
    @url      = "#{Settings.access_url}/users/login"
    mail(to: @user.email,
         subject: t('.title'),
         template_path: 'mailers',
         template_name: 'welcome')
  end


  def password_changed(user, password)
    @user     = user
    @password = password
    @url      = "#{Settings.access_url}/users/login"
    mail(to: @user.email,
         subject: t('.title'),
         template_path: 'mailers',
         template_name: 'password_changed')
  end

end
