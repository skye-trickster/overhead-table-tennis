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