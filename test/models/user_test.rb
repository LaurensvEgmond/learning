require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)

  test "a user should enter a first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end
  test "a user should enter a last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end
  test "a user should enter a profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "A user profile name should be unique" do
  	user = User.new
  	user.profile_name = users(:jason).profile_name


  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
  	user = User.new(first_name: "Jason", last_name: "Tester", email: 'infoer@dium.nl')
    user.password = user.password_confirmation = 'adscfes213'
    
    user.profile_name = "My profile name"

  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end

  test "a user can have a correctly formatted profile name" do 
    user = User.new(first_name: "Jason", last_name: "Tester", email: 'infoer@dium.nl')
    user.password = user.password_confirmation = 'adscfes213'
    user.profile_name = 'testmeout'
    assert user.valid?
  end

  test "that no error is raised when trying to access a friend list" do
    assert_nothing_raised do
      users(:jason).friends
    end
  end

  test "that creating friendships on a user works" do
    users(:jason).pending_friends << users(:mike)
    users(:jason).pending_friends.reload
    assert users(:jason).pending_friends.include?(users(:mike))
  end
  
  test "that calling to_param on a user returns the profile_name" do 
    assert_equal "dium", users(:jason).to_param
  end
end


#puts user.errors.inspect