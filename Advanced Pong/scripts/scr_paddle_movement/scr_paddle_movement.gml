/// @description	Computer-powered movement
/// @self			obj_paddle
function paddle_move_automated() {
	var _vertical = 0;
	if (global.ball.last_paddle != id) {
		var _distance = global.ball.y - y;
		if (abs(_distance) > paddle_speed) {
			_vertical = sign(_distance)	
		}
	} else {
		var _middle = room_height / 2;
		_vertical = sign(_middle - y);
	}
	
	var _y = y + _vertical * paddle_speed;
	var _half_height = sprite_height / 2

	if (_y + _half_height > room_height) {
		_y = room_height - _half_height
	} else if (_y - _half_height < 0) {
		_y = _half_height;
	}

	y = _y
}

/// @description	Player-powered movement
/// @self			obj_paddle
function paddle_move_player() {
	var _vertical = 0;
	
	switch(player_type) {
		case PADDLE_SIDE.LEFT:
			_vertical = LEFT_INPUT_VERTICAL;
			break;
		case PADDLE_SIDE.RIGHT:
			_vertical = RIGHT_INPUT_VERTICAL;
			break;
	}
	
	var _y = y + _vertical * paddle_speed;
	var _half_height = sprite_height / 2

	if (_y + _half_height > room_height) {
		_y = room_height - _half_height
	} else if (_y - _half_height < 0) {
		_y = _half_height;
	}

	y = _y
}