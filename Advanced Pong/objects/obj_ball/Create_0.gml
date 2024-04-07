/// @desc Initialize ball

function reset_ball(_settings = {_adjust_y_value: false, _center_y: true}) {
	xspeed = 0;
	yspeed = 0;
	current_speed = initial_speed;
	speed_multiplier = 1;
	x = starting_point;
}

current_speed = 0;
last_paddle = id;
starting_point = x;
serving_player = 0;
switch_next_turn = false;
playing = false;
