class UserMailer < ApplicationMailer

  def account_activation( user )
    @user = user
    mail to: @user.email, subject: "RandBand Account Activation"
  end

  def password_reset( user )
    @user = user
    mail to: @user.email, subject: "RandBand Password Reset"
  end
end
