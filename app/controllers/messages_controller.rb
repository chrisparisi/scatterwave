class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def index
    if current_user == @conversation.sender || current_user == @conversation.recipient
      @other = current_user == @conversation.sender ? @conversation.recipient : @conversation.sender
      @messages = @conversation.messages.order('created_at DESC').paginate(page: params[:page], per_page: 5)
    else
      redirect_to conversations_path, alert: "You don't have permission to view this."
    end
  end

  def create
    @message = @conversation.messages.new(message_params)
    @messages = @conversation.messages.order('created_at DESC')
    recipient = current_user == @conversation.sender ? @conversation.recipient : @conversation.sender
    if @message.save
    recipient_content = render_message(@message, "left")
    sender_content = render_message(@message, "right")
    ActionCable.server.broadcast "conversation_#{@conversation.id}", message: sender_content, uid: current_user.id
    ActionCable.server.broadcast "conversation_#{@conversation.id}", message: recipient_content, uid: recipient.id
    end
  end

  def more_messages
    @messages = @conversation.messages.where("id <= ?", params[:last]).order('created_at DESC').paginate(page: params[:page], per_page: 5)
  end

  private

  def render_message(message, class_name)
    render_to_string(:partial  => 'messages/message.html.erb', :locals => {message: message, class_name: class_name})
    #render(partial: 'messages/message.html.erb', locals: { message: message, class_name:  class_name})
  end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:context, :user_id)
  end
end
