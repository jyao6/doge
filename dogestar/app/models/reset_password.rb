class ResetPassword < ActiveRecord::Base
  belongs_to :user

  def ResetPassword.new_token(user_id, token)
  	  reset = ResetPassword.find_or_initialize_by_user_id(user_id)
  	  new_token = User.encrypt(token)
  	  reset.update(token: new_token)
  end

end
