$('document').ready(function(){


  $('#friends').on('click', function(){
    viewFriends();
    $('#friends').hide();
    var r= $('<input type="button"  value="Hide Friends" id="hideFriends"/>');
          $("#hide").append(r);
    });

  $('#hide').on('click', function(){
    $('#allFriends').hide();

    $('#friends').show();
    $('#hideFriends').remove();

  })


  $('#lenders').click(function(){
    viewLenders();
    $('#lenders').hide();
    var r= $('<input type="button"  value="Hide Lenders" id="hideLenders"/>');
          $("#hideL").append(r);
  });

  $('#hideL').on('click', function(){
    $('#allLenders').hide();
    $('#lenders').show();
    $('#hideLenders').remove();
  })

  $('#borrowers').click(function(){
    viewBorrowers();
    $('#borrowers').hide();
    var r= $('<input type="button"  value="Hide Borrowers" id="hideBorrowers"/>');
          $("#hideB").append(r);
  });

  $('#hideB').on('click', function(){
    $('#allBorrowers').hide();

    $('#borrowers').show();
    $('#hideBorrowers').remove();
  })

})

function hideFriendsButton(){
  var button ="<button>" + 'Hide Friends' + "</button>";
  return $('#hideFriends').html(button);
}

var url = this.window.location.pathname;

function viewFriends(){
  $.getJSON(url).done(function(response) {
    showFriends(response.users[0]);
  })
}

function showFriends(friends){
  var dom = $();
  var i = 0 ;

  if (friends.length == 0){
    url = "<a href=" + url + '/add_friends' + ">" + "Add a new friend(because you don't have any)" + "</a>";
    $("#allFriends").html(url);
  }else{

  friends.forEach(function(friend){
    dom = dom.add(showFriend(friend.friend));
    i++;
  })
  $("#allFriends").html(dom);
}
    $('#allFriends').show();
}

var showFriend = function(friend) {
  // return $('<li>', { 'data-friendid': friend.id, text: friend.name});
    return "<ul><a href=" + friend.id + ">" + friend.name + "</a></ul>";
}

function viewLenders(){
  $.getJSON(url).done(function(response) {
    showLenders(response.users[0]);
  })
}

function showLenders(response){
  var dom = $();

  response.forEach(function(friend){
    if (friend.amount > 0){
      dom = dom.add(showLender(friend.friend, friend.amount));
    }
  })

  $('#allLenders').html(dom);
    if (dom.length ==0){
      var empty = "You are Debt Free my Man!";
      $('#allLenders').html(empty);
    }
  $('#allLenders').show();
}

var showLender = function(friend, amount) {
  // return $('<li>', { 'data-friendid': friend.id, text: friend.name});
  if (amount > 0){
    return "<ul><a href=" + friend.id + ">" + friend.name + "-" + amount +"</a></ul>";
  }
}


function viewBorrowers(){
  $.getJSON(url).done(function(response) {
    showBorrowers(response.users[0]);
  })
}

function showBorrowers(response){
  var dom = $();

  response.forEach(function(friend){
    if (friend.borrower){
      dom = dom.add(showBorrower(friend.friend, friend.borrower));
    }
  })

  $('#allBorrowers').html(dom);
    if(dom.length == 0){
      var empty = "There is no one that you have to hunt for money. Life is great.";
      $('#allBorrowers').html(empty);
    }

  $('#allBorrowers').show();

}

var showBorrower = function(friend, amount) {
  // return $('<li>', { 'data-friendid': friend.id, text: friend.name});
  if (amount > 0){
    return "<ul><a href=" + friend.id + ">" + friend.name + "-" + amount +"</a></ul>";
  }
}
