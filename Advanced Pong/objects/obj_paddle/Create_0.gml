/// @description Initializes the paddle

set_paddle(self, player_type);

automated_variables = {
	difficulty: PADDLE_AI_DIFFICULTY.MEDIUM,			// paddle AI difficulty. Higher numbers mean more difficult
	target: undefined,
	ball_direction: -1,
	bounces: 0,
	ball_distance: 0,
	closing_in: false,
	closing_in_timer: 0,
	closing_in_max_timer: 0.5,
	closing_in_refresh_chance: 0.75,
	speed: 0,
	state: PADDLE_AI_STATE.RECEIVING,
	lerp_amount: 0.1,
}

power_state = PADDLE_POWER_STATE.NONE;

/// @self	obj_paddle
function on_paddle_collision(_ball, _speed, _angle) {
	show_debug_message({
		_speed, _angle
	});
	switch(power_state) {
		case PADDLE_POWER_STATE.POWER_READY:
		case PADDLE_POWER_STATE.SUPER_READY:
			power_state = PADDLE_POWER_STATE.NONE;
		break;
		
		case PADDLE_POWER_STATE.NONE:
			var _top_distance = abs(_ball.return_angle) - abs(_angle)
			var _middle_distance = abs(_angle)
			show_debug_message({_top_distance, _middle_distance});
			// TODO: gain points based on the smaller of the two distances and the speed
			super_meter_amount = min(super_meter_amount + base_meter_gain * 0.55, super_meter_max);
			power_meter_amount += base_meter_gain;
			if (power_meter_amount > power_meter_max) {
				var _extra_meter = power_meter_amount - power_meter_max;
				power_meter_amount -= _extra_meter;
				super_meter_amount = min(super_meter_amount + _extra_meter * 0.25, super_meter_max);
			}
			show_debug_message({power_meter_amount, super_meter_amount});
		break;
	}
}