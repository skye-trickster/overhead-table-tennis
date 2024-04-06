/// @description Insert description here
// You can write your code in this editor

if (GAME_PAUSED) {
	var _width = display_get_gui_width();
	var _height = display_get_gui_height();

	draw_set_color(c_black);
	draw_set_alpha(0.5);
	draw_rectangle(0, 0, _width, _height, false);
	show_debug_message("width: " + string(display_get_width()) + " height: " + string(display_get_height()));
	show_debug_message("width: " + string(window_get_width()) + " height: " + string(window_get_height()));
}