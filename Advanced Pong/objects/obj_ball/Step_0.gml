/// @desc Movement and Collision

if (GAME_PAUSED) return;

/// @funciton		move_ball()
/// @description	move the ball and bounce according to collision rules
function move_ball() {
	var _y = y + yspeed;
	var _x = x + xspeed;

	// bounce off of a wall
	if (place_meeting(_x, _y, obj_wall)) {
		var _bounce_amount = 0;
		do {
			_y -= sign(yspeed);
			_bounce_amount += sign(yspeed);
		} until(!place_meeting(_x, _y, obj_wall) or abs(_bounce_amount) >= abs(yspeed))
		_y -= _bounce_amount;

		yspeed *= -1;
		audio_play_sound(snd_wall_hit, 1, 0);
	}

	// bounce off of a paddle
	var _paddle = instance_place(_x, _y, obj_paddle);
	if (_paddle and _paddle.id != last_paddle) {		

		if (power_state == BALL_POWER_STATE.SUPER) {
			// stop the ball at the paddle and tally the score when hit with a super
			x = _paddle.id.x - 16 * sign(xspeed);
			// explode the paddle and tally 5 points
			tally_score(self, 5, _paddle);
			return;
		}

		align_power_states(_paddle);
		
		var _bounce_amount = 0;
		do {
			_x -= sign(xspeed);
			_bounce_amount += sign(xspeed);
		} until(!place_meeting(_x, _y, obj_paddle) or abs(_bounce_amount) >= abs(xspeed))
		_x -= _bounce_amount;

		var _modified_speed = get_modified_speed()
		if (_modified_speed < maximum_speed) {
			speed_multiplier += speed_increase
			current_speed = clamp(_modified_speed * power_multiplier, 0, maximum_speed * power_multiplier);
		}
	
		// find distance percentage and return angle based on the paddle y location
		var _distance_percent = (y - _paddle.y) / ((_paddle.sprite_height / 2) + (sprite_height / 2));
		var _theta = clamp(_distance_percent * return_angle, -return_angle, return_angle);
		xspeed = dcos(_theta) * current_speed * -sign(xspeed);
		yspeed = dsin(_theta) * current_speed;
		last_paddle = _paddle.id;
		if (power_state == BALL_POWER_STATE.POWER or power_state == BALL_POWER_STATE.SUPER) {
			audio_play_sound(snd_shot, 1, 0);
		} else {
			audio_play_sound(snd_paddle_hit, 1, 0);
		}
		
		// perform collision code with paddle
		_paddle.id.on_paddle_collision(self, current_speed, _theta);
	}

	y = _y;
	x = _x;
	if (trail) {
		trail.x = x;	
	}
}

function move_fast_ball() {
	var _y_distance = yspeed;
	var _x_distance = xspeed;

	var _speed_ticker = current_speed;
	var _x_speed_normalized = xspeed / current_speed;
	var _y_speed_normalized = yspeed / current_speed;

	while(_speed_ticker > 0) {
		// bounce off of a wall if it's about to hit one
		if (place_meeting(x, y + _y_speed_normalized, obj_wall)) {
			yspeed *= -1;
			_y_speed_normalized *= -1;
			audio_play_sound(snd_wall_hit, 1, 0);
		}

		
		// bounce off of a paddle if it's about to hit one
		var _paddle = instance_place(x + _x_speed_normalized, y, obj_paddle);
		
		if (_paddle and _paddle.id != last_paddle) {
			if (power_state == BALL_POWER_STATE.SUPER) {
				x = _paddle.id.x - 16 * sign(xspeed);
				tally_score(self, 5, _paddle);
				return;
			}
			
			align_power_states(_paddle);
			var _modified_speed = get_modified_speed();
			
			if (_modified_speed < maximum_speed) {
				speed_multiplier += speed_increase
				current_speed = clamp(_modified_speed * power_multiplier, 0, maximum_speed * power_multiplier);
			}
			var _distance_percent = (y - _paddle.y) / ((_paddle.sprite_height / 2) + (sprite_height / 2));
			var _theta = clamp(_distance_percent * return_angle, -return_angle, return_angle);
			xspeed = dcos(_theta) * current_speed * -sign(xspeed);
			yspeed = dsin(_theta) * current_speed;
			last_paddle = _paddle.id;
			if (power_state == BALL_POWER_STATE.POWER or power_state == BALL_POWER_STATE.SUPER) {
				audio_play_sound(snd_shot, 1, 0);
			} else {
				audio_play_sound(snd_paddle_hit, 1, 0);
			}
			// perform collision code with paddle
			_paddle.id.on_paddle_collision(self, current_speed, _theta);
			_x_speed_normalized *= -1;
		}

		x += _x_speed_normalized;
		y += _y_speed_normalized;
		_speed_ticker--
	}
}

if (playing and current_speed >= 15) {	
	move_fast_ball();
} else if (playing) {
	move_ball();	
}
