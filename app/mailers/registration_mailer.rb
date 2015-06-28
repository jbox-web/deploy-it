class RegistrationMailer < ActionMailer::Base

  default from: "no-reply@jbox-web.com"

  def welcome(user, password)
    @user     = user
    @password = password
    @url      = 'https://deployer.jbox-web.fr/users/login'
    mail(to: @user.email,
         subject: "Welcome to Deploy'It",
         template_path: 'mailers',
         template_name: 'welcome')
  end


  def password_changed(user, password)
    @user     = user
    @password = password
    @url      = 'https://deployer.jbox-web.fr/users/login'
    mail(to: @user.email,
         subject: "Your Deploy'It password has changed",
         template_path: 'mailers',
         template_name: 'password_changed')
  end

end
