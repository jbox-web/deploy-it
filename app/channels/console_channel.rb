class ConsoleChannel < ApplicationCable::Channel
  def subscribed
    stream_for "/console-streamer/#{params[:request_id]}"
  end
end
