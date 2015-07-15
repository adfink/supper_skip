class NotificationMailer < ApplicationMailer   #ActionMailer::Base
  default from: "from@example.com"
  def staff_registration_email(email_address)
    # binding.pry
    mail(to: email_address, subject: "You're hired!")
  end
end
