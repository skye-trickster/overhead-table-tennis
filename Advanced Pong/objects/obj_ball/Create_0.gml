/// @desc Initialize ball

/// @self			obj_ball
function reset_ball(_settings = {_move_ball: false}) {
	xspeed = 0;
	yspeed = 0;
	current_speed = initial_speed;
	speed_multiplier = 1;

	if (_settings._move_ball) {
		x = starting_point;
	}
}

current_speed = 0;
last_paddle = id;
starting_point = x;
serving_player = 0;
switch_next_turn = false;
playing = false;
