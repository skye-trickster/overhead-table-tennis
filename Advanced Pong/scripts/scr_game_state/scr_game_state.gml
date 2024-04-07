enum GAME_STATE {
	NOT_SPECIFIED,
	MENU,
	PLAYING,
	BETWEEN_POINTS,
	PAUSING,
}

global.game_state = GAME_STATE.NOT_SPECIFIED;
global.game_object = noone;

#macro GAME_PAUSED global.game_state == GAME_STATE.PAUSING

global.paddle = {
	"PADDLE_SIDE.LEFT": {
		id: noone,
		score: 0,
	},
	"PADDLE_SIDE.RIGHT": {
		id: noone,
		score: 0,
	}
};
global.ball = noone;

/// @funcion		set_paddle(instance, side)
/// @description	Sets the paddle
/// @param {Id.Instance} _instance the object instance
/// @param {real.PADDLE_SIDE} _side the side to set the paddle on.
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

enum PADDLE_SIDE {
	LEFT,
	RIGHT
}