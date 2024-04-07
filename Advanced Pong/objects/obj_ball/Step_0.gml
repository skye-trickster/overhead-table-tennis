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
		audio_play_sound(snd_paddle_hit, 1, 0);
	}

	y = _y;
	x = _x;

}

move_ball();
