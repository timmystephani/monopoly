var api = {

	//endPoint: 'http://localhost:3000/api/v1/',
	endPoint: 'http://prod-monopoly.herokuapp.com/',

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
		$.ajax({
			url: api.endPoint + 'games/' + ui.gameId + '/respond_to_property_purchase',
			data: { 'yes_no': yesNo },
			success: function(data) {
				callback(data);
			},
			error: function() {
				alert('ERROR: couldnt respond to property purchase.');
			}
		});
	},

	payOutOfJail: function(callback) {
		$.ajax({
			url: api.endPoint + 'players/' + ui.currentPlayerId + '/pay_out_of_jail',
			success: function(data) {
				callback(data);
			},
			error: function() {
				alert('ERROR: couldnt respond to pay out of jail.');
			}
		});
	},

	respondToIncomeTax: function(twoHundredOrTenPercent, callback) {
		$.ajax({
			url: api.endPoint + 'games/' + ui.gameId + '/respond_to_income_tax',
			data: { 'two_hundred_or_ten_percent': twoHundredOrTenPercent },
			success: function(data) {
				callback(data);
			},
			error: function() {
				alert('ERROR: couldnt respond to income tax.');
			}
		});
	}
};