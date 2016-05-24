$('document').ready(function(){

  $('#friends').click(function(){
    viewFriends();
  });

  $('#lenders').click(function(){
    viewLenders();
  });

})

var url = this.window.location.pathname;

function viewFriends(){
  $.getJSON(url).done(function(response) {
    showFriends(response.users[0].friends, response.users[1]);
  })
}




function showFriends(friends, amount){
  var dom = $();
  var i = 0 ;
  friends.forEach(function(friend){
    dom = dom.add(showFriend(friend, amount[i]));
    i++;
  })
    $("#allFriends").html(dom);
}

var showFriend = function(friend, amount) {
  // return $('<li>', { 'data-friendid': friend.id, text: friend.name});
    return "<ul><a href=" + friend.id + ">" + friend.name + "-" + amount + "</a></ul>";
}

function viewLenders(){
  $.getJSON(url).done(function(response) {
    showLenders(response);
  })
}

function showLenders(response){
  debugger;
}
