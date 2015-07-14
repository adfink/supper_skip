class NotificationMailer < ActionMailer::Base
  def staff_registration_email(email_address)
    mail(to: email_address, subject: "You're hired!")
  end
end
