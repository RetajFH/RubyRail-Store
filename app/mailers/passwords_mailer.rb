class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Reset your password", to: user.email_address
  end
  def in_stock
    @product = params[:product]
    mail to: params[:subscriber].email
  end
end
