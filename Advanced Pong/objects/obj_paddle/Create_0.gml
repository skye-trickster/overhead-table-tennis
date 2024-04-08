/// @description Initializes the paddle

set_paddle(self, player_type);

automated_variables = {
	target: y,
	speed: 0,
	state: PADDLE_AI_STATE.RECEIVING,
	lerp_amount: 0.1,
}