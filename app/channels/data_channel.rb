class DataChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user.private_channel
  end
end
