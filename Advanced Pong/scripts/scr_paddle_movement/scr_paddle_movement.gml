enum PADDLE_AI_STATE {
	RECEIVING,	// when the ball is going towards the paddle
	SERVING		// when the ball is going away from the paddle
}

/// @description	Computer-powered movement
/// @self			obj_paddle
function paddle_move_automated() {
	
	switch(automated_variables.state) {
		case PADDLE_AI_STATE.RECEIVING:
			switch (global.game_state) {
				case GAME_STATE.BETWEEN_POINTS:
					// reset when you're between points
					automated_variables.target = undefined;
					paddle_move_point(room_height / 2);
				break;

				case GAME_STATE.PLAYING:
					// move to the ball when the paddle in play
					if (automated_variables.target == undefined or sign(global.ball.yspeed) != automated_variables.ball_direction) {
						paddle_find_ball_target();
					}
					paddle_move_point(automated_variables.target);
					
					if (global.ball.last_paddle == id) {
						automated_variables.state = PADDLE_AI_STATE.SERVING;
					}
				break;
			}
		break;
		
		case PADDLE_AI_STATE.SERVING:
			paddle_move_point(room_height / 2);
			if (global.ball.last_paddle != id) {
				paddle_find_ball_target();
				automated_variables.state = PADDLE_AI_STATE.RECEIVING;	
			}
		break;
	}
}

/// @function					paddle_find_ball_target()
/// @self						obj_paddle
function paddle_find_ball_target() {
	// calculate the horizontal distance between the ball and the player. 
	var _distance_x = x - global.ball.x;
	_distance_x -= sign(_distance_x) * 16; // 16 because half of the ball's sprite height + half of the paddle's height
	// find out how long it will take to get to the paddle
	var _time = _distance_x / global.ball.xspeed;
	// find the equivalent distance on the y-axis
	var _distance_y = global.ball.yspeed * _time;

	// calculate expected area assuming no walls
	var _target = real(_distance_y + global.ball.y);

	// calculate the number of expected bounces
	var _bounces = 0
	
	// reduce _distance_y if going above the field
	if (_target < WALL_HEIGHT) {

		// first bounce
		_distance_y += (global.ball.y - WALL_HEIGHT);
		_bounces = 1;
		
		// remaining bounces
		_bounces += floor(abs(_distance_y) / FIELD_HEIGHT);
		_distance_y = (_distance_y mod FIELD_HEIGHT) + FIELD_HEIGHT;

		if ((_bounces mod 2) == 1) {
			// even number of bounces come from bottom wall
			_target = BOTTOM_POSITION - abs(_distance_y);
		} else {
			// odd number of bounces come from top wall
			_target = WALL_HEIGHT + abs(_distance_y);
		}
	} else if (_target > BOTTOM_POSITION) { // _target >= BOTTOM_POSITION
		// first bounce
		_distance_y -= (BOTTOM_POSITION - global.ball.y)		
		_bounces = 1;
		
		// remaining bounces
		_bounces += floor(_distance_y / FIELD_HEIGHT);
		_distance_y %= FIELD_HEIGHT;

				
		if ((_bounces mod 2) == 1) {
			// odd number of bounces come from bottom wall
			_target = BOTTOM_POSITION - abs(_distance_y);
		} else {
			// even number of bounces come from top wall
			_target = WALL_HEIGHT + abs(_distance_y);
		}
	}

	automated_variables.target = _target;
	automated_variables.bounces = _bounces;
	automated_variables.ball_direction = sign(global.ball.yspeed);
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