class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protected

  def authenticate_user!
    Rails.env.development? || head(:unauthorized) # change to actually authenticate
  end
end
