class PageMailer < ApplicationMailer

  def contact_us_admin(name, surname, email, message)
    @name = name
    @surname = surname
    @email = email
    @message = message


    mail to: "contact@scatterwave.com",
         from: @email,
         subject: "Contact us"
  end

  def contact_us_user( name, email)
    @name = name
    @email = email

    mail to: @email,
         from: "contact@scatterwave.com",
         subject: "Contact us"
  end

end