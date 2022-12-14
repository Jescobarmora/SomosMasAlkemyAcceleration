# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  def send_welcome_email(user, subject)
    @user = user
    @subject = subject
    mail(to: @user.email, subject: @subject)
  end
end
