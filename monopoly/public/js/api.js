var api = {

	endPoint: 'http://localhost:3000/api/v1/',

	loadBoardSpaces: function(callback) {
		$.ajax({
			url: api.endPoint + 'board_spaces',
			success: function(data) {
				ui.boardSpaces = data;
				callback();
			},
			error: function() {
				alert('ERROR: Couldnt retreive board spaces.');
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
				alert('ERROR: Couldnt get game info.');
			}
		});
	}, 

	respondToPropertyPurchase: function(yesNo, callback) {
		var gameId = $('#gameId').val();

		$.ajax({
			url: api.endPoint + 'games/' + gameId + '/respond_to_property_purchase',
			data: { 'yes_no': yesNo },
			success: function(data) {
				callback(data);
			},
			error: function() {
				alert('ERROR: couldnt respond to property purchase.');
			}
		});
	}
};