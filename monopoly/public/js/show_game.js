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

			api.refreshGame(callback);
		});
	},

	refreshGame: function(data) {
		alert(data);
	},

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

	refreshGame: function(callback) {
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