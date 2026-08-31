class ProductMailer < ApplicationMailer
  def in_stock
    @product = params[:product]
    @subscriber = params[:subscriber]
    mail to: @subscriber.email
  end
end