# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authentic_client!, only: %i[create]

  def create
    if set_session
      flash[:success] = 'Nickname set successfully!'
    else
      flash[:error] = 'Failed to set nickname.'
    end
    redirect_to games_path
  end

  private

  def session_params
    params.require(:user).permit(:nickname)
  end

  def set_session
    nickname = session_params[:nickname]
    return false unless nickname.present?

    session[:current_user] = {
      player_session_id: SecureRandom.uuid,
      nickname: nickname
    }

    true
  end
end
