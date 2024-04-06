/// @description global game logic

switch(global.game_state) {
	case GAME_STATE.MENU:
		if(INPUT_CONFIRM_BUTTON_PRESSED) {
			var _ball = instance_find(obj_ball, 0);
			with(_ball) {
				start_serve();
			}
			global.game_state = GAME_STATE.PLAYING;
		}
		break;
	case GAME_STATE.PLAYING:
		// pause
		if (INPUT_PAUSE_BUTTON_PRESSSED) {
			global.game_state = GAME_STATE.PAUSING;
		}
		break;
	case GAME_STATE.PAUSING:
		if (INPUT_PAUSE_BUTTON_PRESSSED) {
			global.game_state = GAME_STATE.PLAYING;
		}
		break;
}