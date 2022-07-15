class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :context, :conversation_id, :user_id, presence: true
  after_create_commit :create_notification

  def message_time
    created_at.strftime('%v')
  end

  private

  def create_notification
    if conversation.sender_id == user_id
      sender = User.find(conversation.sender_id)
      Notification.create(content: "New message from #{sender.fullname}", user_id: conversation.recipient_id)
    else
      sender = User.find(conversation.recipient_id)
      Notification.create(content: "New message from #{sender.fullname}", user_id: conversation.sender_id)
    end
  end
end
