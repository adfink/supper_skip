class NotificationsController < ApplicationController


  def create
    NotificationMailer.staff_registration_email(params[:email]).deliver_now
    redirect_to root_path
  end
end
