/// @desc Movement and Collision

switch(state) {
	case BALL_STATE.WAITING:
		if(INPUT_CONFIRM_BUTTON_PRESSED) {
			start_serve();
			state = BALL_STATE.PLAYING;
		}
		break;
	case BALL_STATE.PLAYING:
		move_ball();
		if (x < 0 or x > room_width) {
			if (switch_next_turn) {
				serving_player = (serving_player + 1) mod 2;
			}

			switch_next_turn = not switch_next_turn;
			reset_ball({_adjust_y_value: true, _center_y: false});
			start_serve();
		}
		break;
}

/// @funciton		move_ball()
/// @description	move the ball and bounce according to collision rules
function move_ball() {
	var _y = y + yspeed;
	var _x = x + xspeed;

	if (place_meeting(_x, _y, obj_wall)) {
		var _bounce_amount = 0;
		do {
			_y -= sign(yspeed);
			_bounce_amount += sign(yspeed);
		} until(!place_meeting(_x, _y, obj_wall) or abs(_bounce_amount) >= abs(yspeed))
		_y -= _bounce_amount;

		yspeed *= -1;
	}

	var _paddle = instance_place(_x, _y, obj_paddle);

	if (_paddle and _paddle.id != last_paddle) {

		var _bounce_amount = 0;
		do {
			_x -= sign(xspeed);
			_bounce_amount += sign(xspeed);
		} until(!place_meeting(_x, _y, obj_paddle) or abs(_bounce_amount) >= abs(xspeed))
		_x -= _bounce_amount;

		if (current_speed < maximum_speed) {
			speed_multiplier += speed_increase
			current_speed = clamp(initial_speed * speed_multiplier, 0, maximum_speed);
		}
	
		// find distance percentage and return angle based on the paddle y location
		var _distance_percent = (y - _paddle.y) / ((_paddle.sprite_height / 2) + (sprite_height / 2));
		var _theta = clamp(_distance_percent * return_angle, -return_angle, return_angle);
		xspeed = dcos(_theta) * current_speed * -sign(xspeed);
		yspeed = dsin(_theta) * current_speed;	
		last_paddle = _paddle.id;
	}

	y = _y;
	x = _x;
}