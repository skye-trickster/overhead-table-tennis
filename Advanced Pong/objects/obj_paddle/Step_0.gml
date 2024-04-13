/// @description Move the paddle up and down

if (GAME_PAUSED) return;

switch(global.game_state) {
	case GAME_STATE.PLAYING:
	case GAME_STATE.BETWEEN_POINTS:
		if (automated) {
			paddle_move_automated();	
		} else {
			paddle_move_player();	
		}
		paddle_power_behavior();
		power_meter.update();
		break;
}

power_color.update();
super_color.update();