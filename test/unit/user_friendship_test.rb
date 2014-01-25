require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)

  test "that creating a friendship works without raising an exception" do
  	assert_nothing_raised do
      UserFriendship.create user: users(:tate), friend: users(:mike)
    end    
  end

  test "that creating a friendship based on user id and friend id works" do
  	UserFriendship.create user_id: users(:tate).id, friend_id: users(:mike).id
    assert users(:tate).pending_friends.include?(users(:mike))
  end

  context "a new instance" do
    setup do
      @user_friendship = UserFriendship.new user: user(:tate), friend: users(:mike)
    end

    should "have a pending state" do
      assert_equal 'pending', @user_friendship.state
    end
  end 

  context "#send_request_email" do
    setup do
     @user_friendship = UserFriendship.create user: user(:tate), friend: users(:mike)
    end

    should "send an email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        @user_friendship.send_request_email
      end
    end
  end 

  context "#mutual_friendship" do
    setup do
      UserFriendship.request users(:tate), users(:bill)
      @friendship1 = users(:tate).user_friendships.where(friend_id: users(:bill).id).first
      @friendship2 = users(:bill).user_friendships.where(friend_id: users(:tate).id).first  
    end

    should "correctly find the mutual friendship" do
      assert_equal @friendship2, @friendship1.mutual_friendship    
    end 
  end

  context "#accept_mutual_friendship!" do
    setup do
      UserFriendship.request users(:tate), users(:bill)
    end

    should "accept the mutual friendship" do
      friendship1 = users(:tate).user_friendships.where(friend_id: users(:bill).id).first
      friendship2 = users(:bill).user_friendships.where(friend_id: users(:tate).id).first   
    
      friendship1.accept_mutual_friendship!
      friendship2.reload
      assert_equal 'accepted', friendship2.state
    end
  end

  context "#accept!" do 
    setup do
      @user_friendship = UserFriendship.request users(:tate), users(:mike)
    end

    should "set the state to accepted" do
      @user_friendship.accepted!
      assert_equal "accepted", @user_friendship.state
    end

    should "send an acceptance email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      end
    end

    should "include the friend in the list of friends" do
      @user_friendship.accepted!
      users(:tate).friends.reload
      assert users(:tate).friends.include?(users(:mike))
    end 

    should "accept the mutual friendship" do
      @user_friendship.accept!
      assert_equal 'accepted', @user_friendship.mutual_friendship.state
      end
    end

  context ".request" do
    should "create two user friendships" do
      assert_difference 'UserFriendship.count', 2 do
        UserFriendship.request(users(:tate), user(:mike))
      end
    end

    should "send a friend requested email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        UserFriendship.request(users(:tate), user(:mike))
      end
    end    
  end

  context "#delete_mutual_friendship!" do
    setup do
      UserFriendship.request users(:tate), users(:bill)
      @friendship1 = users(:tate).user_friendships.where(friend_id: users(:bill).id).first
      @friendship2 = users(:bill).user_friendships.where(friend_id: users(:tate).id).first  
    end

    should "delete the mutual friendship" do
      assert_equal @friendship2, @friendship1.mutual_friendship
      @friendship1.delete_mutual_friendship!
      assert !UserFriendship.exists?(@friendship2.id)
    end 
  end

  context "on destroy" do
    setup do
      UserFriendship.request users(:tate), users(:bill)
      @friendship1 = users(:tate).user_friendships.where(friend_id: users(:bill).id).first
      @friendship2 = users(:bill).user_friendships.where(friend_id: users(:tate).id).first  
    end

    should "delete the mutual friendship" do
      @friendship1.destroy
      assert !UserFriendship.exists?(@friendship2.id)   
    end
  end  

  context "#block!" do
    setup do
      @user_friendship = UserFriendship.request users(:tate), users(:mike)
    end

    should "set the state to blocked" do
      @user_friendship.block!
      assert_equal 'blocked', @user_friendship.state
      assert_equal 'blocked', @user_friendship.mutual_friendship.state
    end

    should "not allow new requests once blocked" do
      @user_friendship.block!
      uf = UserFriendship.request users(:tate), users(:mike)
      assert !uf.save
    end
  end  
end