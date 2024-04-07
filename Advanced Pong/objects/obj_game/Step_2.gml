/// @description Insert description here
// You can write your code in this editor
if (INPUT_PAUSE_BUTTON) {
	quit_timer += DELTA_TIME;
	if (quit_timer > time_to_quit) {
		game_end();	
	}
} else {
	quit_timer = 0;
}