class MessagesController < ApplicationController
    THREADS_PER_PAGE = 25
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

	def index
		@threads = index_helper(:to_id, :from_id)
		@unread = Notification::MsgNotification.where(user_id: current_user.id).group(:sender_id).count
	end

	def index_sent
		@threads = index_helper(:from_id, :to_id)
	end

	private
		def message_params
			m_params = params.require(:message).permit(:body, :to_id, :from_id)
			m_params[:from_id] = current_user.id
			m_params
		end

		def index_helper(w1, w2)
			most_recent = Message.where(w1 => current_user.id).group(w2).maximum(:created_at)
            num_threads = most_recent.length
			most_recent = most_recent.sort_by {|k,v| v}.reverse
			threads = []
            offset = params[:page].to_i - 1 unless params[:page].nil?
			most_recent.drop(THREADS_PER_PAGE * (offset or 0)).first(THREADS_PER_PAGE).each do |uid, created_at|
				threads << Message.where(w2 => uid, created_at: created_at).first
			end
            Kaminari.paginate_array(threads, total_count: num_threads).page(params[:page]).per(THREADS_PER_PAGE)
		end
end
