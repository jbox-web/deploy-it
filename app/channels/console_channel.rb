# frozen_string_literal: true
class ConsoleChannel < ApplicationCable::Channel
  def subscribed
    stream_for "/console-streamer/#{params[:request_id]}"
  end
end
