/// @description Create singleton and initialize game

if (variable_global_exists("game_object") and global.game_object != id) {
	instance_destroy(self);
	return;
} 

global.game_object = id;
persistent = true;
global.game_state = GAME_STATE.MENU;