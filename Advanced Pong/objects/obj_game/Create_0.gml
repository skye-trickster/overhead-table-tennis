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
quit_timer = 0;
point_timer = 0;

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
}