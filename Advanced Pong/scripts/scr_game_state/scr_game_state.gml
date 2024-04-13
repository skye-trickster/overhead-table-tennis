enum GAME_STATE {
	NOT_SPECIFIED,
	MENU,
	PLAYING,
	EXPLOSION,
	BETWEEN_POINTS,
	PAUSING,
	WINNING,
}

enum PADDLE_SIDE {
	LEFT,
	RIGHT,
}

global.game_state = GAME_STATE.NOT_SPECIFIED;

global.game_object = noone;
global.ball = noone;
global.paddle = {};

/// @funcion					set_paddle(instance, side)
/// @description				Sets the paddle
/// @param {Id.Instance}		_instance	the object instance
/// @param {real.PADDLE_SIDE}	_side		the side to set the paddle on.
function set_paddle(_instance, _side) {
	global.paddle[_side] = {
		id: _instance.id,
		score: 0,
	};
}

/// @funcion					get_other_paddle(instance, side)
/// @description				Sets the paddle
/// @param {real.PADDLE_SIDE}	_side	the side to set the paddle on.
/// @returns {id.instance}		the opposing side's paddle
function get_other_paddle(_side) {
	return _side == PADDLE_SIDE.LEFT ? global.paddle[PADDLE_SIDE.RIGHT].id : global.paddle[PADDLE_SIDE.LEFT].id;	
}

function get_all_paddles(_instances = true) {
	if (_instances) {
		return [global.paddle[PADDLE_SIDE.LEFT].id, global.paddle[PADDLE_SIDE.RIGHT].id];			
	}
	
	return [global.paddle[PADDLE_SIDE.LEFT], global.paddle[PADDLE_SIDE.RIGHT]];	
}

function is_in_play() {
	return global.game_state == GAME_STATE.PLAYING or global.game_state == GAME_STATE.EXPLOSION or global.game_state == GAME_STATE.BETWEEN_POINTS;
}