require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context "#index" do
    context "when not logged in" do
      should "redirect to login page" do 
        get :index
        assert_response :redirect
      end
    end
  end

  context "#new" do
    context "when not logged in" do
      should "redirect to login page" do 
        get :new
        assert_response :redirect
      end
    end

    context "when logged in" do 
      setup do
        sign_in users(:jason)
      end

      should "get new and return success" do
        get :new
        assert_response :success
      end

      should "should set a flash error if the friend_id param is missing" do
        get :new, {}
        assert_equal "Friend required", flash[:error]
      end

      should "display the friends name" do
        get :new, friend_id: users(:tom)
        assert_match /#{users(:tom).full_name}/, response.body
      end

      should "assign a new user friendship" do 
        get :new, friend_id: users(:tom)
        assert assigns(:user_friendship)
      end

      should "assign a new user friendship to the correct friend" do 
        get :new, friend_id: users(:tom)
        assert_equal users(:tom), assigns(:user_friendship).friend
      end

      should "assign a new user friendship to currently logged in user" do 
        get :new, friend_id: users(:tom)
        assert_equal users(:jason), assigns(:user_friendship).user
      end

      should "render 404 if the friend can not be found" do
        get :new, friend_id: 'invalid'
        assert_response :not_found
      end

      should "ask if you really wanne request this friendship" do
        get :new, friend_id: users(:tom)
        assert_match /Do you really want to friend #{users(:tom).full_name}?/, response.body
      end
    end
  end

  context "#create" do 
    context "when not logged in" do 
      should "redirect to login page" do 
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:jason)
      end

      context "with no friend_id" do
        setup do
          post :create
        end

        should "set the flash error message" do
          assert !flash[:error].empty?
        end

        should "redirect to site root" do
          assert_redirected_to root_path
        end

      end

      context "with valid friend id" do
        setup do
          post :create, user_friendship: { friend_id: users(:mike) }
        end

        should "assign a friend object" do
          assert assigns(:friend)
          assert_equal users(:mike), assigns(:friend)
        end

        should "assign a user friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:jason), assigns(:user_friendship).user
          assert_equal users(:mike), assigns(:user_friendship).friend
        end

        should "create a friendship" do
          assert users(:jason).pending_friends.include?(users(:mike))
        end

        should "redirect to profile page of friend" do
          assert_response :redirect
          assert_redirected_to profile_path(users(:mike))
        end

        should "set flash message for success" do
          assert flash[:success]
          assert_equal "You are now friends with #{users(:mike).full_name}", flash[:success]
        end

      end
    end
  end
end
