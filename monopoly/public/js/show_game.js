$(document).ready(function() {
	ui.setupClickHandlers();
	api.loadBoardSpaces();
});

var ui = {
	boardSpaces: null,

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
	},

  showOwnedPropPopup: function(data) {
    var html = 'ToDo';

    //need to build for each loop over owned
    //properties to display to screen

    $('#propertyList').html(html);
    $('#ownedPropertiesDiv').popup("open");
  },

	refreshGame: function(data) {
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
			html += players[i].name + ' ($' + players[i].cash + ')' + '<br>';
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
