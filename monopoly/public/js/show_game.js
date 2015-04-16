$(document).ready(function() {
	ui.setupClickHandlers();
	api.loadBoardSpaces();
	api.getGame(function(data) {
		ui.refreshGame(data);
	});
});

var ui = {
	boardSpaces: null,
	currentPlayerId: null,

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
			var gameId = $('#gameId').val();

			$.ajax({
				'url': api.endPoint + 'games/' + gameId + '/roll_dice'
			})
			.done(function(data) {
				api.getGame(function(data) {
					ui.refreshGame(data);
				})
			});
		});
	},

  showOwnedPropPopup: function(data) {
    var html = '';
    var players = data.players;

    for(var i=0; i < players.length; i++) {
      html += players[i].name + ':<br>';
      var owned_properties = players[i].owned_properties;
      for(var j=0; j < owned_properties.length; j++) {
        html += '&nbsp;&nbsp;&nbsp;' + owned_properties[j] + '<br>';
      }
    }

    $('#propertyList').html(html);
    $('#ownedPropertiesDiv').popup("open");
  },

	refreshGame: function(data) {
		ui.currentPlayerId = data.current_player_id;
		ui.refreshPlayers(data.players);
		ui.refreshHistory(data.history);
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

			html += players[i].name + ' ($' + players[i].cash + ')';

			var currentBoardSpace;
			for (var boardSpaceIndex = 0; boardSpaceIndex < ui.boardSpaces.length; boardSpaceIndex++) {
				var boardSpace = ui.boardSpaces[boardSpaceIndex];

				if (boardSpace.position == player.position) {
					currentBoardSpace = boardSpace;
					break;
				}
			}

			html += ' ' + currentBoardSpace.name;

			if (player.id == ui.currentPlayerId) {
				html += ' <strong>Current Player</strong>';
			}
			html += '<br>';
		}

		$('#players').html(html);
	}
};

var api = {

	endPoint: 'http://localhost:3000/api/v1/',

	loadBoardSpaces: function() {
		$.ajax({
			url: api.endPoint + 'board_spaces',
			success: function(data) {
				ui.boardSpaces = data;
			},
			error: function() {
				alert('ERROR');
			}
		});
	},

	getGame: function(callback) {
		var gameId = $('#gameId').val();

		$.ajax({
			url: api.endPoint + 'games/' + gameId,
			success: function(data) {
				callback(data);
			},
			error: function() {
				alert('ERROR');
			}
		});
	}
};
