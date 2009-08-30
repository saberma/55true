class FriendshipsController < ApplicationController
  before_filter :xhr_check_login, :xhr_check_score
  @@score = ADD_FRIEND_SCORE

  def create
    if Friendship.added?(current_user.id, params[:friend_id])
      flash.now[:notice] = "已经加为好友了!"
      render :partial => '/shared/notice' and return 
    end
    friendship = Friendship.new(:user => current_user, :friend_id => params[:friend_id])
    friendship_reverse = Friendship.new(:user_id => params[:friend_id], :friend => current_user)
    Friendship.transaction do
      friendship.save!
      friendship_reverse.save!
      Message.create({
        :creator => current_user,
        :user_id => params[:friend_id], 
        :content => ERB.new(Message::ADD_FRIEND_CONTENT).result(binding)
      })
    end
    flash.now[:notice] = "添加好友成功!花费积分#{@@score}"
    render :partial => '/shared/notice'
  end
end
