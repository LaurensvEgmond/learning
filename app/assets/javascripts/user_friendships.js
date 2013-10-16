window.userFriendships = [];


$(document).ready(function(){

  $.ajax({
    url: Routes.user_friendships_path({format: 'json'}),
    dataType: 'json',
    type: 'GET',
    success: function(data){
      window.userFriendships = data;
    }
  })


  $('#add-friendship').on('click', function(e){
    e.preventDefault();
    var addFriendshipBtn = $(this);
    $.ajax({
      dataType: 'json',
      type: 'POST',
      url: Routes.user_friendships_path({user_friendship: { friend_id: addFriendshipBtn.data('friendId') } }),
      success: function(e){
        addFriendshipBtn.hide();
        $('#friend-status').html('<a href="#" class="btn btn-success">Friendship Requested</a>');
      }
    });

  });

});