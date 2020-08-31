class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications.#{current_user.id}"
  end
end
