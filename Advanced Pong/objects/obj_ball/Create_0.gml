/// @desc Initialize ball

enum BALL_POWER_STATE {
	NONE,
	POWER,
	SUPER
}

/// @function		reset_ball(settings)
/// @description	Reset the ball's speed and additional positions
/// @param {Struct}	_settings	Additional settings for the function
/// @self			obj_ball
function reset_ball(_settings = {_move_ball: false}) {
	xspeed = 0;
	yspeed = 0;
	current_speed = initial_speed;
	speed_multiplier = 1;

	if (_settings._move_ball) {
		x = starting_point;
	}
	power_state = BALL_POWER_STATE.NONE;
}

current_speed = 0;
last_paddle = id;
starting_point = x;
serving_player = 0;
switch_next_turn = false;
playing = false;
power_state = BALL_POWER_STATE.NONE;
power_multiplier = 1; // how much the ball has sped up because of power.

trail = noone;
part = noone;

function get_modified_speed() {
	return initial_speed * speed_multiplier;
}

/// @function			change_ball_power_state(state)
/// @param {Real.ENUM}	_state the ball power state
/// @self				obj_ball
function change_ball_power_state(_state) {
	power_state = _state;
	var _modified_speed = get_modified_speed();
	switch(_state) {
		case BALL_POWER_STATE.NONE:
			power_multiplier = 1;
		break;
		case BALL_POWER_STATE.POWER:
			_modified_speed = get_modified_speed();
			power_multiplier = max(power_speed_multiplier, base_power_speed / _modified_speed)
		break;
		case BALL_POWER_STATE.SUPER:
			_modified_speed = get_modified_speed();
			power_multiplier = max(super_speed_multiplier, base_super_speed/ _modified_speed)
		break;
	}
}

function align_power_states(_paddle) {
	var _power = BALL_POWER_STATE.NONE;
	switch(_paddle.id.power_state) {
		case PADDLE_POWER_STATE.POWER_READY:
			_power = BALL_POWER_STATE.POWER;
		break;
		case PADDLE_POWER_STATE.SUPER_READY:
			_power = BALL_POWER_STATE.SUPER;
		break;
	}
	change_ball_power_state(_power);
}