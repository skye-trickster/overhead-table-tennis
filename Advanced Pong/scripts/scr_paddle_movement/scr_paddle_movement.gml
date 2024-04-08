enum PADDLE_AI_STATE {
	RECEIVING,	// when the ball is going towards the paddle
	SERVING		// when the ball is going away from the paddle
}

/// @description	Computer-powered movement
/// @self			obj_paddle
function paddle_move_automated() {
	
	switch(automated_variables.state) {
		case PADDLE_AI_STATE.RECEIVING:
			paddle_follow_ball();
			if (global.ball.last_paddle == id) {
				automated_variables.state = PADDLE_AI_STATE.SERVING;
			}
		break;
		
		case PADDLE_AI_STATE.SERVING:
			paddle_move_point(room_height / 2);
			if (global.ball.last_paddle != id) {
				// TODO: find intended target of the ball
				automated_variables.state = PADDLE_AI_STATE.RECEIVING;	
			}
		break;
	}
}

function paddle_follow_ball() {
	var _vertical = 0;
	automated_variables.speed = 0;
	var _distance = global.ball.y - y;
	if (abs(_distance) > paddle_speed) {
		_vertical = sign(_distance);
		automated_variables.speed = sign(_distance);
	}
	
	var _y = y + _vertical * paddle_speed;
	var _half_height = sprite_height / 2;
	y = clamp(_y, _half_height, room_height - _half_height);
}

function paddle_move_point(_target) {
	var _distance = _target - y;
	if (abs(_distance) < paddle_speed) {
		y = _target;
		automated_variables.speed = 0;
		return;
	}
	automated_variables.speed = lerp(automated_variables.speed, sign(_distance), automated_variables.lerp_amount);
	var _y = y + paddle_speed * automated_variables.speed;
	var _half_height = sprite_height / 2;
	
	y = clamp(_y, _half_height, room_height - _half_height);

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