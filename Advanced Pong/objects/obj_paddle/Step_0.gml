/// @description Move the paddle up and down

if (GAME_PAUSED) return;

var _vertical = 0;

if (automated) {
	var _ball = instance_find(obj_ball, 0);
	if (_ball.last_paddle != id) {
		var _distance = _ball.y - y;
		if (abs(_distance) > ball_threshold) {
			_vertical = sign(_distance);
		}
	} else {
		var _middle = room_height / 2;
		_vertical = sign(_middle - y);
	}
} else {
	switch(player_type) {
		case "left":
			_vertical = LEFT_INPUT_VERTICAL;
			break;
		case "right":
			_vertical = RIGHT_INPUT_VERTICAL;
			break;
	}		
}

var _y = y + _vertical * paddle_speed;
var _half_height = sprite_height / 2

if (_y + _half_height > room_height) {
	_y = room_height - _half_height
} else if (_y - _half_height < 0) {
	_y = _half_height;
}

y = _y