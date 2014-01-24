class MessagesController < ApplicationController
	def new
		@rel_messages = Message.where('(to_id=? AND from_id=?) OR (to_id=? AND from_id=?)', params[:other_id], current_user.id, current_user.id, params[:other_id]).order(created_at: :asc)		
		@message = Message.new
	end

	def create
		@message = Message.create(message_params)
		if @message.save
			flash[:success] = "Message sent."
			redirect_to '/messages/' + @message.to_id.to_s
		else
			render "new"
		end
	end

	private
		def message_params
			m_params = params.require(:message).permit(:body, :to_id, :from_id)
			m_params[:from_id] = current_user.id
			m_params
		end
end
