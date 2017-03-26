class Api::RootController < ApplicationController
  before_action :authenticate

  def index
    render json: { 'api status' => :cool }
  end

  private

  def authenticate
    render status: :unauthorized unless user_signed_in?
  end
end
