/// @description global game logic

if (INPUT_PAUSE_BUTTON_PRESSSED) {
	global.game_state = GAME_PAUSED ? GAME_STATE.PLAYING : GAME_STATE.PAUSING;
}