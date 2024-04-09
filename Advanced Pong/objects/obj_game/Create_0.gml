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

	serve_ball();
	global.game_state = GAME_STATE.PLAYING;
	global.paddle[PADDLE_SIDE.RIGHT].id.automated = global.automation;
}

function reset_game() {
	if (global.ball) {
		instance_destroy(global.ball);
		global.ball = noone;
	}
	for (var _i = 0; _i < array_length(global.paddle); _i++) {
		global.paddle[_i].score = 0;
		global.paddle[_i].id.y = room_height / 2;
	}
	global.game_state = GAME_STATE.MENU;
	global.main_menu.selected = 0;
	global.pause_menu.selected = 0;
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
		serving_side = PADDLE_SIDE.LEFT ? PADDLE_SIDE.RIGHT : PADDLE_SIDE.LEFT;
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