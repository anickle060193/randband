class UserMailer < ApplicationMailer

  def account_activation( user )
    @user = user
    mail to: user.email, subject: "Choose-a-Band Account Activation"
  end

  def password_reset( user )
    @user = user
    mail to: user.email, subject: "Choose-a-Band Password Reset"
  end
end
