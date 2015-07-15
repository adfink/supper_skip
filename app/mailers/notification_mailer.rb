class NotificationMailer < ApplicationMailer   #ActionMailer::Base
  default from: "from@example.com"
  def staff_registration_email(email_address, user_role, restaurant)
    @user_role = user_role
    @restaurant = restaurant
    # binding.pry
    mail(to: email_address, subject: "You're hired!")
  end
end
