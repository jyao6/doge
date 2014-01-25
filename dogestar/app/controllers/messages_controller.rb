class MessagesController < ApplicationController
	def new
		@rel_messages = Message.where('(to_id=? AND from_id=?) OR (to_id=? AND from_id=?)', params[:other_id], current_user.id, current_user.id, params[:other_id]).order(created_at: :asc)		
		@message = Message.new
		MsgNotification.destroy_all(user_id: current_user.id, sender_id: params[:other_id])
	end

	def create
		@message = Message.new(message_params)
		if @message.save
			flash[:success] = "Message sent."
			redirect_to messages_path(@message.to_id)
		else
			render "new"
		end
	end

	def inbox
		#get all unique users they hve messages with
		#sort in order of latest message
		#search for msgnotification. if there are display # next to name
		  # or just look at all message notifications and add to that user
	end

	private
		def message_params
			m_params = params.require(:message).permit(:body, :to_id, :from_id)
			m_params[:from_id] = current_user.id
			m_params
		end
end
