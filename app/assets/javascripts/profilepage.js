$('document').ready(function(){

  $('#friends').click(function(){
    viewFriends();
  });

})

var url = this.window.location.pathname;

function viewFriends(){


  $.getJSON(url).done(function(response) {
    showFriends(response.user.friends);
  })

}

function showFriends(friends){
  var dom = $();

debugger;
  friends.forEach(function(friend){
    debugger;
    dom = dom.add(showFriend(friend));
  })
    $("#allFriends").html(dom);
}

var showFriend = function(friend) {
  debugger;
  // return $('<li>', { 'data-friendid': friend.id, text: friend.name});
    return "<ul><a href=" + friend.id + ">" + friend.name + "</a></ul>";
}
