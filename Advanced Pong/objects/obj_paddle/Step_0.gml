/// @description Move the paddle up and down

if (GAME_PAUSED) return;

switch(global.game_state) {
	case GAME_STATE.PLAYING:
		if (automated) {
			paddle_move_automated();	
		} else {
			paddle_move_player();	
		}
		break;
}
