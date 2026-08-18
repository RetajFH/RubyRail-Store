class UnsubscribesController < ApplicationController
  allow_unauthenticated_access
  before_action :set_supscriber

  def show
    @subscriber&.destroy
    redirect_to root_path, note: " unsubscribe successfuly"
  end
  private
  def set_supscriber
    @subscriber =Subscriber.find_by_token_for(:unsubscribe, param[:token])
  end
end
