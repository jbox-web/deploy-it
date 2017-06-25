class ConsoleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "/console-streamer/#{params[:request_id]}"
  end
end
