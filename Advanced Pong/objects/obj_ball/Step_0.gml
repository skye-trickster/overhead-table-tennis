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
			effect_create_depth(depth, ef_explosion, x, y, 1, c_orange);
			tally_score(self);
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
			show_debug_message(current_speed);
		}
	
		// find distance percentage and return angle based on the paddle y location
		var _distance_percent = (y - _paddle.y) / ((_paddle.sprite_height / 2) + (sprite_height / 2));
		var _theta = clamp(_distance_percent * return_angle, -return_angle, return_angle);
		xspeed = dcos(_theta) * current_speed * -sign(xspeed);
		yspeed = dsin(_theta) * current_speed;
		last_paddle = _paddle.id;
		audio_play_sound(snd_paddle_hit, 1, 0);
		
		// perform collision code with paddle
		_paddle.id.on_paddle_collision()
	}

	y = _y;
	x = _x;
	if (trail) {
		trail.x = x;	
	}

}

if (playing) move_ball();
