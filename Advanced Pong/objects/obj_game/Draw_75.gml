/// @description Insert description here
// You can write your code in this editor
var _variables = draw_store_variables();

if (quit_timer > 0) {
	var _alpha = (quit_timer / time_to_quit);
	draw_set_color(c_black);
	draw_set_alpha(_alpha);
	draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
}

draw_set_variables(_variables);