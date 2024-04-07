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
	var _ball = global.ball;
	var _paddle = global.paddle[serving_side].id;
	_ball.last_paddle = get_other_paddle(serving_side);

	_ball.reset_ball();
	_ball.x = _ball.starting_point;
	_ball.y = _center ? y : _paddle.y;
	_ball.depth = depth;

	var _angle = random_range(-_ball.return_angle / 2, _ball.return_angle / 2);
	_ball.xspeed = dcos(_angle) * _ball.current_speed * sign(_paddle.x - x);
	_ball.yspeed = dsin(_angle) * _ball.current_speed;
	_ball.playing = true;
}