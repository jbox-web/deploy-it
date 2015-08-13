class RegistrationMailer < ActionMailer::Base

  default from: "no-reply@jbox-web.com"

  def welcome(user, password)
    render_template('welcome', user, password)
  end


  def password_changed(user, password)
    render_template('password_changed', user, password)
  end


  private


    def render_template(template, user, password)
      @user     = user
      @password = password
      @url      = "#{Settings.access_url}/users/login"
      mail(to: @user.email,
           subject: t('.title'),
           template_path: 'mailers',
           template_name: template)
    end

end
