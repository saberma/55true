class FriendshipsController < ApplicationController
  layout 'facebox'
  before_filter :xhr_check_login, :check_added, :xhr_check_score
  @@score = ADD_FRIEND_SCORE

  def create
    @friend = User.find(params[:friend_id])
    friendship = Friendship.new(:user => current_user, :friend => @friend)
    friendship_reverse = Friendship.new(:user => @friend, :friend => current_user)

    Friendship.transaction do
      friendship.save!
      friendship_reverse.save!
      #发消息
      Message.create({
        :creator => User.admin,
        :user => @friend, 
        :content => ERB.new(Message::ADD_FRIEND_CONTENT).result(binding)
      })
      #减积分
      current_user.decrement! :score, ADD_FRIEND_SCORE
    end
    flash.now[:notice] = "添加好友成功!花费积分#{@@score}"
  end

  private
  def check_added
    if Friendship.added?(current_user.id, params[:friend_id])
      flash.now[:notice] = "已经加为好友了!"
      render :partial => '/shared/notice' and return 
    end
  end
end
