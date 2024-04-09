/// @description Initializes the paddle

set_paddle(self, player_type);

automated_variables = {
	target: undefined,
	ball_direction: -1,
	bounces: 0,
	speed: 0,
	state: PADDLE_AI_STATE.RECEIVING,
	lerp_amount: 0.1,
}