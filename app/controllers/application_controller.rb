# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :authentic_client!

  def current_user
    @current_user ||= session[:current_user]
  end

  def authentic_client!
    redirect_to games_path if current_user.blank?
  end
end
