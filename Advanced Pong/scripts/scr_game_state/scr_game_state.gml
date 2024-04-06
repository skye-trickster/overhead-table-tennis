enum GAME_STATE {
	NOT_SPECIFIED,
	MENU,
	PLAYING,
	PAUSING,
}

global.game_state = GAME_STATE.NOT_SPECIFIED;

#macro GAME_PAUSED global.game_state == GAME_STATE.PAUSING