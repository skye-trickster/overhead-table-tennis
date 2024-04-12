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
		case PADDLE_POWER_STATE.SUPER_READY:
			super_meter_amount = 0;
		case PADDLE_POWER_STATE.POWER_READY:
			power_meter_amount = 0;
			power_state = PADDLE_POWER_STATE.NONE;
		break;
		
		case PADDLE_POWER_STATE.NONE:
			var _top_distance = (abs(_ball.return_angle) - abs(_angle));
			var _middle_distance = abs(_angle);
			
			// gain meter the closer you are to the middle of the edge
			var _gained_meter = base_meter_gain * (1 - (min(_top_distance, _middle_distance) / _ball.return_angle));
			
			// gain additional meter based on ball speed multiplier
			// 5/7*(x - 1.1)^2 + 1.1: inflection at 1.1 and 2.5 multipliers
			var _speed_multiplier_bonus = 5 / 7 * power((_ball.speed_multiplier - 1.1), 2) + 1.1;
			
			_gained_meter *= _speed_multiplier_bonus;
			
			// TODO: gain points based on the smaller of the two distances and the speed
			power_meter_amount += _gained_meter;
			super_meter_amount += _gained_meter;
			if (power_meter_amount > power_meter_max) {
				var _extra_meter = power_meter_amount - power_meter_max;
				power_meter_amount -= _extra_meter;
				// gain about half of the meter
				super_meter_amount = super_meter_amount + _extra_meter * 0.5;
			}
			super_meter_amount = min(super_meter_amount, super_meter_max);
		break;
	}
}

function on_paddle_point_end(_win) {
	if (_win) {
		power_meter_amount *= 0.75;
	}
	super_meter_amount = 0;
}