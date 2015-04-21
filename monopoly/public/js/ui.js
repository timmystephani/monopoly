var ui = {
  boardSpaces: null,
  currentPlayerId: null,
  playerId: null,
  gameId: null,

  setupClickHandlers: function() {
    $('#refresh_link').click(function() {
      var callback = function(data) {
        ui.refreshGame(data);
      };

      api.getGame(callback);
    });

    $('#ownedProperties').click(function() {
      var callback = function(data) {
        ui.showOwnedPropPopup(data);
      };

      api.getGame(callback);
    });

    $('#roll_dice').click(function() {
      $.ajax({
        'url': api.endPoint + 'games/' + ui.gameId + '/roll_dice'
      })
      .done(function(data) {
        api.getGame(function(data) {
          ui.refreshGame(data);
        })
      });
    });

    $('#purchase_property_link_no').click(function() {
      api.respondToPropertyPurchase('no', function() {
        $('#property_purchase_popup').popup('close');
        api.getGame(function(data) {
          ui.refreshGame(data);
        });
      });
    });

    $('#purchase_property_link_yes').click(function() {
      api.respondToPropertyPurchase('yes', function() {
        $('#property_purchase_popup').popup('close');
        api.getGame(function(data) {
          ui.refreshGame(data);
        });
      });
    });
    
    $('#jail_options_link_roll').click(function() {
      $('#jail_options_popup').popup('close');

      $.ajax({
        'url': api.endPoint + 'games/' + ui.gameId + '/roll_dice'
      })
      .done(function(data) {
        api.getGame(function(data) {
          ui.refreshGame(data);
        });
      });
    });
    
    $('#jail_options_link_pay').click(function() {
      api.payOutOfJail(function() {
        $('#jail_options_popup').popup('close');
        api.getGame(function(data) {
          ui.refreshGame(data);
        });
      });
    });
  },

  showOwnedPropPopup: function(data) {
    var html = '';
    var players = data.players;

    for(var i=0; i < players.length; i++) {
      html += players[i].name + ':<br>';
      var ownedProperties = players[i].owned_properties;
      for(var j = 0; j < ownedProperties.length; j++) {
        var ownedProperty = ownedProperties[j];

        var boardSpace;
        for (var boardSpaceIndex = 0; boardSpaceIndex < ui.boardSpaces.length; boardSpaceIndex++) {
          if (ownedProperty.board_space_id == ui.boardSpaces[boardSpaceIndex].id) {
            boardSpace = ui.boardSpaces[boardSpaceIndex];
            break;
          }
        }
        html += '&nbsp;&nbsp;&nbsp;' + boardSpace.name + '<br>';
      }
    }

    $('#propertyList').html(html);
    $('#ownedPropertiesDiv').popup("open");
  },

  refreshGame: function(data) {
    ui.currentPlayerId = data.current_player_id;
    ui.refreshPlayers(data.players);
    ui.refreshHistory(data.history);

    if (ui.playerId == ui.currentPlayerId) {
      if (data.status == 'WAITING_ON_USER_INPUT') {
        if (data.user_prompt_type == 'PROPERTY_PURCHASE') {
          $('#property_purchase_popup p').text(data.user_prompt_question);
          $('#property_purchase_popup').popup('open');
        }
      }

      for (var playerIndex = 0; playerIndex < data.players.length; playerIndex++) {
        var player = data.players[playerIndex];
        if (player.id == ui.playerId && player.in_jail) {
          $('#jail_options_popup').popup('open');
        }
      }  
    }
  },

  refreshHistory: function(history) {
    var html = '';

    for (var i = 0; i < history.length; i++) {
      html += '<strong>' + history[i].created_at_formatted + ':</strong> ' + history[i].details + '<br>';
    }

    $('#history').html(html);
  },

  refreshPlayers: function(players) {
    var html = '';

    for (var i = 0; i < players.length; i++) {
      var player = players[i];

      html += player.name + ' ($' + player.cash + ')';

      if (player.in_jail) {
        html += ' In Jail';
      } else {
        var currentBoardSpace;
        for (var boardSpaceIndex = 0; boardSpaceIndex < ui.boardSpaces.length; boardSpaceIndex++) {
          var boardSpace = ui.boardSpaces[boardSpaceIndex];

          if (boardSpace.position == player.position) {
            currentBoardSpace = boardSpace;
            break;
          }
        }

        html += ' ' + currentBoardSpace.name;
      }
      

      if (player.id == ui.currentPlayerId) {
        html += ' <strong>Current Player</strong>';
      }
      html += '<br>';
    }

    $('#players').html(html);
  }
};