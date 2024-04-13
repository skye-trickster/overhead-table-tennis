/// @description Create singleton and initialize game

if (global.game_object and global.game_object != id) {
	if (relocation) {
		global.game_object.x = x;
		global.game_object.y = y;
		global.game_object.layer = layer;
		global.game_object.depth = depth;
	}
	instance_destroy(self);
	return;
}

global.game_object = id;
global.game_state = GAME_STATE.MENU;
serving_side = PADDLE_SIDE.LEFT;
switch_sides = false;
quit_timer = 0;
point_timer = 0;
explosion_timer = 0;
color_rotater = 0;
win_color = c_white;

/// @function		rotate_color()
/// @description	Rotates the win color between the various rainbow colors and set as the win color
function rotate_color() {
	var _colors = [c_red, c_orange, c_yellow, c_green, c_blue, c_purple];
	win_color = _colors[random(6)]
}

/// @function		start_game()
/// @description	creates or moves the ball, resets positions, and starts the game
function start_game() {
	if (not global.ball) {
		global.ball = instance_create_depth(x, y, depth, obj_ball);
	}
	for (var _i = PADDLE_SIDE.LEFT; _i <= PADDLE_SIDE.RIGHT; ++_i) {
		global.paddle[_i].id.reset_paddle(true);
		global.paddle[_i].score = 0;
	}
	if (global.automation) {
		set_ai_difficulty();
		serving_side = global.flip_sides ? PADDLE_SIDE.RIGHT : PADDLE_SIDE.LEFT;
	} else {
		serving_side = PADDLE_SIDE.LEFT;	
	}
	global.ball.initial_speed = global.settings.ball_initial_speed;
	global.ball.speed_multiplier = global.settings.ball_multiplier;
	switch_sides = false;
	serve_ball();
	global.game_state = GAME_STATE.PLAYING;

}

function set_ai_difficulty() {
	var _difficulty = global.difficulty;
	var _low_lerp = 0.1;
	var _high_lerp = 0.9;
	
	var _low_max_timer = 0.5;
	var _high_max_timer = 2.5;
	
	var _low_refresh_chance = 0.5;
	var _high_refresh_chance = 0.95;
	
	var _ai_side = global.flip_sides ? PADDLE_SIDE.LEFT : PADDLE_SIDE.RIGHT;
	var _player_side = global.flip_sides ? PADDLE_SIDE.RIGHT : PADDLE_SIDE.LEFT;

	global.paddle[_player_side].id.automated = false;

	with(global.paddle[_ai_side].id) {
		automated = true;
		automated_variables.difficulty = _difficulty;

		switch(_difficulty) {
			case PADDLE_AI_DIFFICULTY.VERY_LOW:
				automated_variables.lerp_amount = _low_lerp;
			break;
		
			case PADDLE_AI_DIFFICULTY.LOW:
				automated_variables.lerp_amount = _high_lerp;
			break;
		
			case PADDLE_AI_DIFFICULTY.MEDIUM_LOW:
				automated_variables.lerp_amount = _low_lerp;
				automated_variables.closing_in_max_timer = _low_max_timer;
				automated_variables.closing_in_refresh_chance = _low_refresh_chance;
			break;
		
			case PADDLE_AI_DIFFICULTY.MEDIUM:
				automated_variables.lerp_amount = _high_lerp;
				automated_variables.closing_in_max_timer = _high_max_timer;
				automated_variables.closing_in_refresh_chance = _high_refresh_chance;
			break;
		}
	}
}

function reset_game() {
	if (global.ball) {
		instance_destroy(global.ball);
		global.ball = noone;
	}
	// feather ignore GM1041
	for (var _i = 0; _i < array_length(global.paddle); _i++) {
		global.paddle[_i].id.y = room_height / 2;
		global.paddle[_i].id.reset_paddle(false);
	}
	global.game_state = GAME_STATE.MENU;
	global.main_menu.selected = 0;
	global.pause_menu.selected = 0;
	serving_side = PADDLE_SIDE.LEFT;
	switch_sides = false;
	quit_timer = 0;
	point_timer = 0;
	explosion_timer = 0;
	color_rotater = 0;
	win_color = c_white;
}

function serve_ball(_center = false) {
	var _side = serving_side;
	var _paddle = global.paddle[serving_side].id;
	
	global.ball.x = global.ball.starting_point;
	global.ball.y = _center ? y : _paddle.y;
	global.ball.depth = depth;
	global.ball.last_paddle = get_other_paddle(_paddle.player_type);

	with (global.ball) {
		reset_ball();
		var _angle = random_range(-return_angle / 2, return_angle / 2);
		xspeed = dcos(_angle) * current_speed * sign(_paddle.x - x);
		yspeed = dsin(_angle) * current_speed;
		playing = true;
	}
	
	with(_paddle) {
		if (automated) {
			paddle_find_ball_target();
		}
	}
}

function switch_serve() {
	if (switch_sides) {
		serving_side = serving_side == PADDLE_SIDE.LEFT ? PADDLE_SIDE.RIGHT : PADDLE_SIDE.LEFT;
	}

	switch_sides = not switch_sides;
}

function end_game() {
	if (NOT_ON_BROWSER) {
		game_end();
	}
}

function resume_game() {
	global.pause_menu.selected = 0;
	global.game_state = GAME_STATE.PLAYING;
}

rotate_color();