$(document).ready(function() {
	ui.setupClickHandlers();
	var callback = function() {
		api.getGame(function(data) {
			ui.refreshGame(data);
		});
	};

	api.loadBoardSpaces(callback);
});

