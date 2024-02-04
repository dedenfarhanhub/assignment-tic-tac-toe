# frozen_string_literal: true

class GamesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "games_channel_#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
