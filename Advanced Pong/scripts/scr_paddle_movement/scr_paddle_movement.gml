enum PADDLE_AI_STATE {
	RECEIVING,	// when the ball is going towards the paddle
	SERVING		// when the ball is going away from the paddle
}

enum PADDLE_AI_DIFFICULTY {
	VERY_LOW = 0,		// the simplest AI difficulty
	LOW = 1,			// the simplest AI difficulty but without lerp
	MEDIUM_LOW = 2,		// the more sophisticated difficulty
	MEDIUM = 3,			// the more sophisticated difficulty
}

function paddle_easy_behavior() {
	switch(automated_variables.state) {
		case PADDLE_AI_STATE.RECEIVING:
			switch(global.game_state) {
				case GAME_STATE.BETWEEN_POINTS:
					paddle_move_point(MIDDLE);
				break;
				
				case GAME_STATE.PLAYING:
					// just follow the ball position
					paddle_follow_ball();
				break;
			}
		break;
		case PADDLE_AI_STATE.SERVING:
			// go to the midle to better get a handle on things
			paddle_move_point(MIDDLE);
			if (global.ball.last_paddle != id) {
				paddle_find_ball_target();
				automated_variables.state = PADDLE_AI_STATE.RECEIVING;	
			}
		break;
	}
}

function paddle_medium_behavior() {
	switch(automated_variables.state) {
		case PADDLE_AI_STATE.RECEIVING:
			switch (global.game_state) {
				case GAME_STATE.BETWEEN_POINTS:
					// reset when you're between points
					automated_variables.target = undefined;
					paddle_move_point(room_height / 2);
				break;

				case GAME_STATE.PLAYING:
					// find the ball if the target is suspected to have changed
					if (automated_variables.target == undefined or sign(global.ball.yspeed) != automated_variables.ball_direction) {
						paddle_find_ball_target();
					}
					
					// start closing in if you're getting too close to the wire
					if (too_close_to_ball() and automated_variables.closing_in == false) {
						refresh_close_in_chance(true);
					}
					
					if (automated_variables.closing_in) {
						paddle_move_point(automated_variables.target);
						automated_variables.closing_in_timer += DELTA_TIME;
						// refresh close in if the timer is up
						if (automated_variables.closing_in_timer > automated_variables.closing_in_max_timer) {
							refresh_close_in_chance(false);
						}
					} else {
						paddle_follow_ball();	
					}

					// reset if it detects that it hit the ball
					if (global.ball.last_paddle == id) {
						automated_variables.closing_in = false;
						automated_variables.target = undefined;
					}
				break;
			}
		break;
		
		case PADDLE_AI_STATE.SERVING:
			paddle_move_point(room_height / 2);
			if (global.ball.last_paddle != id) {
				// find the ball target when switching
				paddle_find_ball_target();
			}
		break;
	}
}

/// @description	Computer-powered movement based on difficulty
/// @self			obj_paddle
function paddle_move_automated() {
	switch(automated_variables.difficulty) {
		case PADDLE_AI_DIFFICULTY.VERY_LOW:
		case PADDLE_AI_DIFFICULTY.LOW:
			paddle_easy_behavior();
		break;
		
		case PADDLE_AI_DIFFICULTY.MEDIUM_LOW:
		case PADDLE_AI_DIFFICULTY.MEDIUM:
			paddle_medium_behavior();
		break;
		
		default:
			paddle_easy_behavior();
		break;
	}
	
	// common behaviors between the difficulties. used for state switching
	switch(automated_variables.state) {
		case PADDLE_AI_STATE.RECEIVING:
			if (global.ball.last_paddle == id) {
				automated_variables.state = PADDLE_AI_STATE.SERVING;
			}
		break;
		
		case PADDLE_AI_STATE.SERVING:
			if (global.ball.last_paddle != id) {
				automated_variables.state = PADDLE_AI_STATE.RECEIVING;	
			}
		break;
	}
}

/// @function		too_close_to_ball()
///	@self			obj_paddle
/// @description	checks to see if the ball is approaching the paddle too quickly and has to close in
/// @returns {Bool}	true if the ball is approaching too close. false otherwise
/// @pure
function too_close_to_ball() {
	return automated_variables.ball_distance == 0 or abs(x - global.ball.x) < abs(global.ball.xspeed * 2) * automated_variables.ball_distance;
}

/// @function		refresh_close_in_chance(guarantee)
/// @param {Bool}	_guarantee	whether or not the guarantee that the paddle should close in on the ball.
/// @description	refreshes the closing in timer and gives a chance of whether or not the paddle should refresh it closing in
function refresh_close_in_chance(_guarantee = false) {
	automated_variables.closing_in = _guarantee or random(1) > automated_variables.closing_in_refresh_chance;
	automated_variables.closing_in_timer = 0;
}

/// @function		paddle_find_ball_target()
/// @description	calculate's the ball intended y-position based on its speed and sets that data
/// @self			obj_paddle
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
	
	// calculate how long it will take to get to the point
	_time = (_target - y) / paddle_speed;
	// calculate how far away the ball needs to be to get to the point
	_distance_x = abs(_time * global.ball.xspeed);

	// refresh close in chance if it's set to true on bounce
	if (automated_variables.closing_in == true) {
		refresh_close_in_chance();
	}

	// set AI variables
	automated_variables.target = _target;
	automated_variables.bounces = _bounces;
	automated_variables.ball_direction = sign(global.ball.yspeed);
	automated_variables.ball_distance = _distance_x;
}

function paddle_follow_ball() {
	var _distance = global.ball.y - y;
	if (abs(_distance) > paddle_speed) {
		automated_variables.speed = lerp(automated_variables.speed, sign(_distance), automated_variables.lerp_amount);
	} else {
		automated_variables.speed = lerp(automated_variables.speed, 0, automated_variables.lerp_amount);	
	}
	var _y = y + automated_variables.speed * paddle_speed;
	var _half_height = sprite_height / 2;

	y = clamp(_y, _half_height, room_height - _half_height);
}

function paddle_move_point(_target) {
	var _distance = _target - y;
	if (abs(_distance) < paddle_speed) {
		y = _target;
		automated_variables.speed = lerp(automated_variables.speed, 0, automated_variables.lerp_amount);
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
			_vertical = global.automation ? INPUT_VERTICAL : LEFT_INPUT_VERTICAL;
			break;
		case PADDLE_SIDE.RIGHT:
			_vertical = global.automation ? INPUT_VERTICAL : RIGHT_INPUT_VERTICAL;
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